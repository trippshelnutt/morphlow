resource "aws_ecs_cluster" "api" {
  for_each = local.environments

  name = "${each.key}_api_cluster"
}

resource "aws_ecs_cluster_capacity_providers" "api_capacity" {
  for_each = local.environments

  cluster_name = aws_ecs_cluster.api[each.key].name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}