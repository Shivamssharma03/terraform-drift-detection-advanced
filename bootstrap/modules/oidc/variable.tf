variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "repo_subs" {
  description = "repo url for github actions"
  type        = list(string)
}

variable "allowed_actions" {
  description = "List of allowed IAM actions for the role"
  type        = list(string)
  default     = ["AdministratorAccess"]
}