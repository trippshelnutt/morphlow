resource "aws_ecs_service" "api_service" {
  for_each = local.environments

  name            = "${each.key}_api_service"
  cluster         = aws_ecs_cluster.api_cluster[each.key].id
  task_definition = aws_ecs_task_definition.api_task[each.key].arn
  launch_type     = "FARGATE"
  desired_count   = 2

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets          = [for key, subnet in aws_subnet.private_subnet : subnet.id if startswith(key, each.key)]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api_blue_target_group[each.key].arn
    container_name   = "morphlow-server"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.https_listener]

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }
}

resource "aws_ecs_service" "app_service" {
  for_each = local.environments

  name            = "${each.key}_app_service"
  cluster         = aws_ecs_cluster.app_cluster[each.key].id
  task_definition = aws_ecs_task_definition.app_task[each.key].arn
  launch_type     = "FARGATE"
  desired_count   = 2

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets          = [for key, subnet in aws_subnet.private_subnet : subnet.id if startswith(key, each.key)]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_blue_target_group[each.key].arn
    container_name   = "morphlow-client"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.https_listener]

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }
}