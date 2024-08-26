resource "aws_ecs_task_definition" "api_task" {
  for_each = local.environments

  family                   = "${each.key}_morphlow_server"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  task_role_arn            = data.aws_iam_role.morphlow_task_role.arn
  execution_role_arn       = data.aws_iam_role.morphlow_execution_role.arn
  container_definitions    = <<JSON
[
  {
    "name": "morphlow-server",
    "image": "${data.aws_ecr_repository.morphlow_server_repository.repository_url}",
    "essential": true,
    "portMappings": [{
        "protocol": "tcp",
        "containerPort": 8081
    }]
  }
]
JSON

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}