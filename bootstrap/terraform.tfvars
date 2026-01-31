role_name = "github-actions-oidc-role"
repo_subs = [
  "repo:Shivamssharma03/terraform-drift-detection-advanced:*"
]
allowed_actions = [
  "s3:*",
  "dynamodb:*",
  "ec2:*",
  "iam:*",
  "logs:*",
  "cloudwatch:*"
]

bucket_name = "shivam-terraform-remote-state-avhi"
lock_table  = "terraform-locks"