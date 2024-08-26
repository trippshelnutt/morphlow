resource "aws_ecr_repository" "ecr_client_repository" {
  name                 = "morphlow-client"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = "morphlow"
  }
}

resource "aws_ecr_repository_policy" "ecr_client_repository_policy" {
  repository = aws_ecr_repository.ecr_client_repository.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage"
        ]
      }
    ]
  })
}

resource "aws_ecr_repository" "ecr_server_repository" {
  name                 = "morphlow-server"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = "morphlow"
  }
}

resource "aws_ecr_repository_policy" "ecr_server_repository_policy" {
  repository = aws_ecr_repository.ecr_server_repository.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage"
        ]
      }
    ]
  })
}
