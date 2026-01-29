resource "aws_s3_bucket" "state" {
  bucket = var.bucket_name
}

resource "aws_dynamodb_table" "lock" {
  name         = var.lock_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

// s3 and dynamodb table creation for terraform backend
