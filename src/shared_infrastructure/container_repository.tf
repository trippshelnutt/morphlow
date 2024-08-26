data "aws_ecr_repository" "morphlow_server_repository" {
  name = "morphlow-server"
}

data "aws_ecr_repository" "morphlow_client_repository" {
  name = "morphlow-client"
}
