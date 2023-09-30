resource "aws_ecr_repository" "apprepo" {
  name = "app_repo"
}

output "aws_ecr_repository_endpoint" {
  value = aws_ecr_repository.apprepo.repository_url
}

