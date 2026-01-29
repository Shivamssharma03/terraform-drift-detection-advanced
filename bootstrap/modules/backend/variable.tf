variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
}

variable "lock_table" {
  description = "Name of the DynamoDB table for Terraform state locking"
  type        = string
}

variable "terraform_role_arn" {
  type        = string
  description = "IAM role ARN allowed to access and decrypt Terraform state"
}
