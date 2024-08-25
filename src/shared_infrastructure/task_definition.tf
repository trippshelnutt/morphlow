resource "aws_ecs_task_definition" "server" {
  for_each = local.environments

  family                   = "morphlow-server"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  task_role_arn            = "arn:aws:iam::879381268419:role/morphlow-github"
  execution_role_arn       = "arn:aws:iam::879381268419:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
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
}