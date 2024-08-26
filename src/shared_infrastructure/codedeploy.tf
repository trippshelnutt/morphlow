resource "aws_codedeploy_app" "api_codedeploy_app" {
  for_each = local.environments

  compute_platform = "ECS"
  name             = "${each.key}_api_code_deploy_app"
}

resource "aws_codedeploy_deployment_group" "api_codedeploy_group" {
  for_each = local.environments

  app_name               = aws_codedeploy_app.api_codedeploy_app[each.key].name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "${each.key}_api_codedeploy_group"
  service_role_arn       = aws_iam_role.morphlow_codedeploy_role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.api_cluster[each.key].name
    service_name = aws_ecs_service.api_service[each.key].name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.listener[each.key].arn]
      }

      target_group {
        name = aws_lb_target_group.api_blue_target_group[each.key].name
      }

      target_group {
        name = aws_lb_target_group.api_green_target_group[each.key].name
      }
    }
  }
}