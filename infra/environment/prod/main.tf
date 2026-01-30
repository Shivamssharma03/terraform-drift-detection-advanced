module "ec2" {
  source        = "./modules/ec2"
  environment   = var.environment
  instance_type = var.instance_type
}

module "s3" {
  source      = "../../modules/s3"
  environment = var.environment
  bucket_name = var.bucket_name
}
 