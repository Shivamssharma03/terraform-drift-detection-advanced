provider "aws" {
  region = "us-east-1"

}


module "oidc" {
  source = "./modules/oidc"

  #   role_name = "github-actions-oidc-role"
  role_name = var.role_name
  # repo_subs = [
  #     "repo:Shivamssharma03/terraform-drift-detection-advanced:ref:refs/heads/*"
  #   ]
  repo_subs = var.repo_subs
  #   allowed_actions = [
  #     "s3:*",
  #     "dynamodb:*",
  #     "ec2:*",
  #     "iam:*",
  #     "logs:*",
  #     "cloudwatch:*"
  #   ]
  allowed_actions = var.allowed_actions
}

module "backend" {
  source = "./modules/backend"

  # bucket_name = "shivam-terraform-remote-state"
  bucket_name = var.bucket_name


  # lock_table  = "terraform-locks"
  lock_table = var.lock_table
  # terraform role is kms role and this is for encrypting the s3 bucket using kms we provide our oidc role to decprty the objects in s3
  terraform_role_arn = module.oidc.role_arn

  depends_on = [module.oidc]
}





