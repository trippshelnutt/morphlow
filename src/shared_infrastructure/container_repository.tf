resource "aws_ecr_repository" "ecr_repository" {
  name                 = "morphlow_containers"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Project = "morphlow"
  }
}
