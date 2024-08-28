resource "aws_ecs_cluster" "api_cluster" {
  for_each = local.environments

  name = "${each.key}_api_cluster"

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_ecs_cluster_capacity_providers" "api_capacity" {
  for_each = local.environments

  cluster_name = aws_ecs_cluster.api_cluster[each.key].name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_cluster" "app_cluster" {
  for_each = local.environments

  name = "${each.key}_app_cluster"

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_ecs_cluster_capacity_providers" "app_capacity" {
  for_each = local.environments

  cluster_name = aws_ecs_cluster.app_cluster[each.key].name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}
