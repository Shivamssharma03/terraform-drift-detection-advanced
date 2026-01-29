data "aws_caller_identity" "current" {}

resource "aws_kms_key_policy" "terraform_state" {
  key_id = aws_kms_key.terraform_state.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowRootAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" /// allow root user full access
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "AllowTerraformRole"
        Effect = "Allow"
        Principal = {
          AWS = var.terraform_role_arn   ///// this is iam role arn from oidc module
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      },

      {
        # this is to allow secrets manager to use the kms key for encrypting secrets 
        Sid    = "AllowSecretsManager"
        Effect = "Allow"
        Principal = {
          Service = "secretsmanager.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }

      
    ]
  })
}
// KMS key policy to allow only specific IAM role to access the key and root user maintain full access 