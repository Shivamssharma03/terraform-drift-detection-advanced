variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "repo_subs" {
  description = "List of repository subscriptions"
  type        = list(string)
}
variable "allowed_actions" {
  description = "List of allowed IAM actions for the role"
  type        = list(string)

}

variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
}

variable "lock_table" {
  description = "Name of the DynamoDB table for Terraform state locking"
  type        = string
}