provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "vulnerable_bucket" {
  bucket = "my-vulnerable-bucket"
  acl    = "public-read"  # Public read access - security risk

  versioning {
    enabled = false  # Versioning is disabled - security risk
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  logging {
    target_bucket = ""  # Logging not configured - security risk
  }
}

resource "aws_security_group" "insecure_sg" {
  name        = "insecure-sg"
  description = "Security group with overly permissive rules"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allows all inbound traffic - security risk
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  # Allows all outbound traffic - security risk
  }
}

resource "aws_instance" "insecure_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "insecure-instance"
  }

  key_name      = "my-key"  # Assuming the key is not stored securely
}
