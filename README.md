# Terraform Infrastructure CI/CD (Apply & Drift Detection)

This repository implements a **secure, production-ready Terraform CI/CD setup**
using **GitHub Actions**, **AWS OIDC authentication**, and **Terraform best practices**.

It covers:
- Controlled **Terraform Apply** with manual approval
- Automated **Terraform Drift Detection**
- Secure **Terraform backend bootstrap**
- **Least-privilege IAM** with **OIDC (no access keys or secret keys)**

---

## 📁 Repository Structure├── infra/
│ └──modules
│ 
│ └── environment/
│ ├── dev/
│ │ ├── main.tf
│ │ ├── backend.tf
│ │ └── variables.tf
│ └── prod/
│ ├── main.tf
│ ├── backend.tf
│ └── variables.tf
│
├── bootstrap/
│ ├── s3-backend.tf
│ ├── dynamodb.tf
│ ├── kms.tf
│ └── oidc.tf
│
└── .github/
└── workflows/
├── terraform-apply.yml
└── terraform-drift.yml



---

## 🚀 Terraform Apply Workflow

The **Terraform Apply pipeline** is responsible for safely deploying infrastructure
changes using GitHub Actions.

---

### 🔄 Triggers

- Push to `main` or `dev`
- Manual trigger via **GitHub Actions → Run workflow**

---

### 🌱 Branch → Environment Mapping

| Git Branch | Environment | Terraform Directory |
|-----------|-------------|---------------------|
| `main` | prod | `infra/environment/prod` |
| `dev` | dev | `infra/environment/dev` |

The pipeline automatically selects the correct environment based on the branch.

---

### 🔍 Apply Pipeline Steps

1. **Terraform Format**
terraform fmt -check

2. **Terraform Validate**
terraform validate

3. **Terraform Plan**
terraform plan

---

### 🛑 Manual Approval Before Apply

Before running `terraform apply`, the workflow **waits for manual approval**.

Approval is enforced using **GitHub Environments**.

#### 👥 Environment Reviewers

| Environment | Reviewers |
|------------|-----------|
| prod | Platform / Senior DevOps |
| dev | DevOps / Infra Engineers |

Reviewers can **approve or reject** the deployment.
Terraform **cannot apply** without approval.

---

### ✅ Terraform Apply (Post-Approval)

terraform apply

Runs only after approval and only for the selected environment.

---

## 🔍 Terraform Drift Detection Workflow

The **Drift Detection pipeline** checks if real AWS infrastructure
has changed outside Terraform.

---

### ⏰ Triggers

- Scheduled run
- Manual trigger via GitHub Actions

---

### 🌱 Environments Checked

| Environment | Branch | Directory |
|------------|--------|-----------|
| dev | `dev` | `infra/environment/dev` |
| prod | `main` | `infra/environment/prod` |

Drift detection runs **even if no code changes exist**.

---

### 🧠 Drift Detection Logic

The workflow uses:


terraform plan -detailed-exitcode


| Exit Code | Meaning |
|----------|--------|
| `0` | No drift |
| `2` | Drift detected |
| `1` | Terraform error |

---

### 🚨 On Drift Detection

When drift is detected:
- Pipeline fails
- Drift report is generated
- Artifact is uploaded
- Email alert is sent

---

## 🏗️ Bootstrap Infrastructure (Backend & Security)

The **bootstrap module** provisions the secure foundation required for Terraform and CI/CD.

---

### 🪣 Terraform Backend

**S3 State Bucket**
- Stores Terraform state
- Encrypted using **AWS KMS**
- Versioning enabled
- Private access only

**DynamoDB Lock Table**
- Used for state locking
- Prevents concurrent applies
- Ensures state consistency

---

### 🔐 KMS Encryption

- Terraform state bucket encrypted with KMS
- Key rotation enabled
- Versioning enabled

**KMS Permissions**
- AWS Root user: full key management
- Terraform CI/CD IAM role: encrypt/decrypt access
- No other principals allowed

---

## 🔑 AWS OIDC Authentication (CI/CD)

GitHub Actions uses **OIDC** to authenticate to AWS.

✔ No AWS Access Key  
✔ No AWS Secret Key  
✔ Temporary STS credentials  
✔ Fully auditable  

---

### 🔒 OIDC Trust Policy (Critical)

The IAM role trust policy strictly enforces:

- Only GitHub Actions
- Only this repository
- Only approved branches



❗ **Only this repository can assume the role. No other repo is allowed.**

---

## 🛡️ Security Guarantees

- No long-lived AWS credentials
- Encrypted Terraform state
- Repo-restricted IAM role
- Manual approval for prod
- Least-privilege access

---

## ✅ Summary

This project provides:

✔ Safe Terraform apply with approval  
✔ Continuous drift detection  
✔ Secure encrypted backend  
✔ OIDC-based CI/CD authentication  
 

---



