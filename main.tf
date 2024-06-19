provider "aws" {
  region = "us-west-2"
}

resource "aws_db_instance" "insecure_db" {
  identifier              = "insecure-db"
  engine                  = "mysql"
  instance_class          = "db.t2.micro"
  allocated_storage       = 20
  username                = "admin"
  password                = "password123"  # Hardcoded credentials - security risk
  parameter_group_name    = "default.mysql5.7"

  publicly_accessible     = true  # Publicly accessible database - security risk
  storage_encrypted       = false # Storage encryption disabled - security risk

  skip_final_snapshot     = true  # No final snapshot on termination - security risk
}

resource "aws_iam_user" "insecure_user" {
  name = "insecure-user"
  path = "/"
}

resource "aws_iam_user_policy" "insecure_user_policy" {
  name = "insecure-policy"
  user = aws_iam_user.insecure_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "*"
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })  # Overly permissive IAM policy - security risk
}

resource "aws_s3_bucket" "another_vulnerable_bucket" {
  bucket = "another-vulnerable-bucket"
  acl    = "public-read-write"  # Public read-write access - security risk

  logging {
    target_bucket = ""  # Logging not configured - security risk
  }

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
}

