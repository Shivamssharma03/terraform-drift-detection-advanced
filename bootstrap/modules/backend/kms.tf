resource "aws_kms_key" "terraform_state" {
  description         = "KMS key for Terraform backend"
  enable_key_rotation = true
}

resource "aws_kms_alias" "terraform_state" {
  name          = "alias/terraform-backend-drift" ///name of kms key alias
  target_key_id = aws_kms_key.terraform_state.key_id
}

