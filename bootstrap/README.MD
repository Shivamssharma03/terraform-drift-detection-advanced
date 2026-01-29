# Terraform Bootstrap – Secure Backend & GitHub Actions OIDC

This repository contains a **production‑grade Terraform bootstrap setup** that creates:

* Secure **S3 remote backend** for Terraform state
* **DynamoDB** table for state locking
* **KMS‑encrypted** Terraform state (SSE‑KMS)
* **GitHub Actions OIDC** integration (no static AWS keys)
* Least‑privilege IAM design

This bootstrap layer is intended to be run **once per AWS account**, and then reused by all other Terraform stacks.

---

## 🔐 Architecture Overview

```text
GitHub Actions
   │ (OIDC token)
   ▼
IAM Role (OIDC‑assumable)
   │
   ├── S3 access (state)
   ├── DynamoDB access (locking)
   └── KMS decrypt permissions

S3 Bucket (Terraform State)
   └── Encrypted with KMS (SSE‑KMS)
```

**Key idea:**

* OIDC answers **WHO you are**
* IAM role answers **WHAT you can do**
* KMS answers **WHO can read the Terraform state**

---

## 📁 Repository Structure

```text
bootstrap/
├── main.tf                # Root module wiring
├── variables.tf           # Root variable declarations
├── outputs.tf             # Root outputs
├── terraform.tfvars       # Input values (not committed)
└── modules/
    ├── oidc/               # GitHub Actions OIDC + IAM role
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── backend/            # Terraform backend resources
        ├── s3.tf +
        ├── dynamodb.tf
        ├── kms.tf
        ├── kms_policy.tf
        ├── s3_encryption.tf
        ├── variables.tf
        └── outputs.tf
```

---

## 🚀 What This Bootstrap Creates

### 1️⃣ GitHub Actions OIDC

* AWS IAM OIDC identity provider
* IAM role assumable by GitHub Actions
* Repo + branch‑level trust policy
* No AWS access keys required

### 2️⃣ Terraform Backend (Secure by Default)

* S3 bucket for Terraform state
* DynamoDB table for state locking
* KMS encryption (SSE‑KMS)
* Versioning enabled
* Public access blocked
* HTTPS enforced

### 3️⃣ KMS Security Model

* Customer‑managed KMS key
* Key rotation enabled
* **ONLY the OIDC IAM role can decrypt Terraform state**
* Root account retained for break‑glass recovery

---

## 🔑 Security Guarantees

| Scenario          | Result                            |
| ----------------- | --------------------------------- |
| S3 bucket leaked  | State unreadable (KMS encrypted)  |
| IAM admin access  | Still blocked without KMS decrypt |
| Local user access | Denied                            |
| Only CI/CD role   | Allowed                           |

> **KMS decrypt permission is the final gatekeeper.**

---

## 🧩 Module Details

### OIDC Module (`modules/oidc`)

Creates:

* `aws_iam_openid_connect_provider`
* `aws_iam_role` with trust policy

Output:

```hcl
output "role_arn" {
  value = aws_iam_role.github_actions.arn
}
```

This ARN is passed to the backend module to control access.

---

### Backend Module (`modules/backend`)

Creates:

* S3 bucket for state
* DynamoDB lock table
* KMS key + alias
* KMS key policy (decrypt restricted)
* S3 SSE‑KMS enforcement

Key variable:

```hcl
variable "terraform_role_arn" {
  description = "IAM role allowed to decrypt Terraform state"
  type        = string
}
```

---

## 🔐 KMS Policy Logic (Important)

```text
KMS key
 ├── Root account → break‑glass access
 └── GitHub OIDC role → encrypt/decrypt Terraform state
```

KMS **does not care about file paths**.
If an object is encrypted with this key, only allowed principals can read it.

---

## 🧪 How to Use This Bootstrap

### 1️⃣ Configure variables

Create `terraform.tfvars`:

```hcl
bucket_name = "my-terraform-remote-state"
lock_table  = "terraform-locks"
role_name   = "github-actions-oidc-role"

repo_subs = [
  "repo:ORG/REPO:ref:refs/heads/*"
]
```

---

### 2️⃣ Initialize and apply bootstrap

```bash
terraform init
terraform apply
```

Run this **once** per AWS account.

---

### 3️⃣ Use the backend in other stacks

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-remote-state"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    kms_key_id     = "alias/terraform-backend"
  }
}
```

---

## 🔁 Handling Manual Changes (Drift)

If a resource is created or modified manually:

1. Define the resource in Terraform
2. Import it:

```bash
terraform import aws_resource.example RESOURCE_ID
```

Only identities that can **decrypt the state** can perform imports.

---

## ❌ What This Bootstrap Intentionally Avoids

* ❌ No static AWS credentials
* ❌ No secrets in Terraform state
* ❌ No public S3 access
* ❌ No human access to state

---

## 🛡️ Best Practices Followed

* Defense in depth (IAM + S3 + KMS)
* Least privilege
* OIDC‑based authentication
* Encrypted state at rest and in transit
* Versioned state with locking

---

## 📌 Important Notes

* This bootstrap **must exist before** other Terraform stacks
* Do not delete the backend bucket or KMS key
* Protect the AWS root account with MFA

---

## ✅ Summary

This bootstrap provides a **secure, scalable, and audit‑friendly Terraform foundation** suitable for production environments.

> **Control KMS decrypt permissions → control Terraform state access**

---


