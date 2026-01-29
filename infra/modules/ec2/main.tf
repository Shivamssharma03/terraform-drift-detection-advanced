resource "aws_security_group" "example" {
  name        = "terraform-ec2-sg"
  description = "Security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# resource "aws_key_pair" "example" {
#   key_name   = "terraform-key"
#   public_key = file("~/.ssh/id_rsa.pub") 
#   
# }
resource "aws_instance" "example" {
  ami             = "ami-0b6c6ebed2801a5cb"
  instance_type   = var.instance_type
  security_groups = [aws_security_group.example.name]
  # key_name      = aws_key_pair.example.key_name

  tags = {
    Name = "terraform-ec2"
  }

}
