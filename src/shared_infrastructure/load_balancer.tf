locals {
  env_load_balancers = flatten([
    for env_key, env in local.environments : {
      env_key         = env_key
      security_groups = [aws_security_group.load_balancer_sg[env_key].id]
      subnets         = [for key, subnet in aws_subnet.public_subnet : subnet.id if startswith(key, env_key)]
      log_bucket_id   = aws_s3_bucket.app_lb_logs[env_key].id
    }
  ])
}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "s3_lb_write" {
  for_each = local.environments

  statement {
    principals {
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
      type        = "AWS"
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.app_lb_logs[each.key].arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "load_balancer_access_logs_bucket_policy" {
  for_each = local.environments

  bucket = aws_s3_bucket.app_lb_logs[each.key].id
  policy = data.aws_iam_policy_document.s3_lb_write[each.key].json
}

resource "aws_s3_bucket" "app_lb_logs" {
  for_each = local.environments

  bucket = "${each.key}-morphlow-lb-logs"

  tags = {
    Project     = "morphlow"
    Environment = each.key
  }
}

resource "aws_lb" "app_load_balancer" {
  for_each = tomap({
    for load_balancer in local.env_load_balancers : "${load_balancer.env_key}" => load_balancer
  })

  name               = "${each.value.env_key}-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = each.value.security_groups
  subnets            = each.value.subnets

  enable_deletion_protection = true

  access_logs {
    bucket  = each.value.log_bucket_id
    prefix  = "${each.value.env_key}_app_lb"
    enabled = true
  }

  tags = {
    Project     = "morphlow"
    Environment = each.value.env_key
  }
}

resource "aws_lb_target_group" "api_blue_target_group" {
  for_each = local.environments

  name        = "${each.key}-api-blue-lb-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc[each.key].id

  health_check {
    path                = "/swagger/index.html"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "api_green_target_group" {
  for_each = local.environments

  name        = "${each.key}-api-green-lb-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc[each.key].id

  health_check {
    path                = "/swagger/index.html"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "app_blue_target_group" {
  for_each = local.environments

  name        = "${each.key}-app-blue-lb-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc[each.key].id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "app_green_target_group" {
  for_each = local.environments

  name        = "${each.key}-app-green-lb-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc[each.key].id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_listener" "https_listener" {
  for_each = local.environments

  load_balancer_arn = aws_lb.app_load_balancer[each.key].arn
  port              = 80
  protocol          = "HTTP"

  # certificate_arn = data.aws_acm_certificate.certificate.arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404 Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "api_routing" {
  for_each = local.environments

  listener_arn = aws_lb_listener.https_listener[each.key].arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_blue_target_group[each.key].arn
  }

  condition {
    host_header {
      values = ["api.qa.morphlow.com"]
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}

resource "aws_lb_listener_rule" "app_routing" {
  for_each = local.environments

  listener_arn = aws_lb_listener.https_listener[each.key].arn
  priority     = 98

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_blue_target_group[each.key].arn
  }

  condition {
    host_header {
      values = ["app.qa.morphlow.com"]
    }
  }

  lifecycle {
    ignore_changes = [action]
  }
}