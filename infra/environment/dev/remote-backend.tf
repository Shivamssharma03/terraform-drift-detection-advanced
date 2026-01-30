terraform {
  backend "s3" {
    bucket         = "shivam-terraform-remote-state-avhi"
    key            = "infra/environment/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    kms_key_id     = "alias/terraform-backend-drift"
  }
}
