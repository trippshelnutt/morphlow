locals {
  env_api_services = flatten([
    for env_key, env in local.environments : {
      env_key         = env_key
      security_groups = [aws_security_group.api_service_sg[env_key].id]
      subnets         = [for key, subnet in aws_subnet.private_subnet : subnet.id if startswith(key, env_key)]
    }
  ])
  env_app_services = flatten([
    for env_key, env in local.environments : {
      env_key         = env_key
      security_groups = [aws_security_group.app_service_sg[env_key].id]
      subnets         = [for key, subnet in aws_subnet.private_subnet : subnet.id if startswith(key, env_key)]
    }
  ])
}

resource "aws_ecs_service" "api_service" {
  for_each = tomap({
    for service in local.env_api_services : "${service.env_key}" => service
  })

  name            = "${each.value.env_key}_api_service"
  cluster         = aws_ecs_cluster.api_cluster[each.value.env_key].id
  task_definition = aws_ecs_task_definition.api_task[each.value.env_key].arn
  launch_type     = "FARGATE"
  desired_count   = 2

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    security_groups  = each.value.security_groups
    subnets          = each.value.subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.api_blue_target_group[each.value.env_key].arn
    container_name   = "morphlow-server"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.https_listener]

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }
}

resource "aws_ecs_service" "app_service" {
  for_each = tomap({
    for service in local.env_app_services : "${service.env_key}" => service
  })

  name            = "${each.value.env_key}_app_service"
  cluster         = aws_ecs_cluster.app_cluster[each.value.env_key].id
  task_definition = aws_ecs_task_definition.app_task[each.value.env_key].arn
  launch_type     = "FARGATE"
  desired_count   = 2

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    security_groups  = each.value.security_groups
    subnets          = each.value.subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_blue_target_group[each.value.env_key].arn
    container_name   = "morphlow-client"
    container_port   = 8080
  }

  depends_on = [aws_lb_listener.https_listener]

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }
}