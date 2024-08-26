resource "aws_ecs_task_definition" "api_task" {
  for_each = local.environments

  family                   = "morphlow-server"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  task_role_arn            = aws_iam_role.morphlow_task_role.arn
  execution_role_arn       = aws_iam_role.morphlow_execution_role.arn
  container_definitions    = <<JSON
[
  {
    "name": "morphlow-server",
    "image": "879381268419.dkr.ecr.us-east-1.amazonaws.com/morphlow_containers",
    "essential": true,
    "portMappings": [{
        "hostPort": 443,
        "protocol": "tcp",
        "containerPort": 443
    }]
  }
]
JSON

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}