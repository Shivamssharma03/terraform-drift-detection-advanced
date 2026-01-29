terraform {
  backend "s3" {
    bucket         = "shivam-terraform-remote-state-avhi"
    key            = "bootstrap/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    kms_key_id     = "alias/terraform-backend-drift"
  }
}
///this is terraform backend configuration for remote state management using s3 and dynamodb with kms encryption
