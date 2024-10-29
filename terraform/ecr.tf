provider "aws" {
  region = "us-east-1"
}

# Define the ECR repository
resource "aws_ecr_repository" "meshy_repo" {
  name                 = "meshy-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true # Enables scan on image push for vulnerabilities
  }

  tags = {
    Name        = "nginx-statuspage-repo"
    Environment = "production"
  }
}

# Define a lifecycle policy for the ECR repository
resource "aws_ecr_lifecycle_policy" "my_ecr_lifecycle_policy" {
  repository = aws_ecr_repository.meshy_repo.name
  policy     = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire untagged images older than 30 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

# Output the repository URL
output "ecr_repository_url" {
  value       = aws_ecr_repository.meshy_repo.repository_url
  description = "The URL of the created ECR repository"
}

