data "aws_security_group" "default_sg" {
  for_each = local.environments

  vpc_id = aws_vpc.vpc[each.key].id
  filter {
    name   = "group-name"
    values = ["default"]
  }
}

resource "aws_security_group" "endpoint_sg" {
  for_each = local.environments

  name        = "${each.key}_endpoint_sg"
  description = "Manage endpoing sg for ${each.key}"
  vpc_id      = aws_vpc.vpc[each.key].id

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "endpoint_allow_all_traffic" {
  for_each = local.environments

  security_group_id = aws_security_group.endpoint_sg[each.key].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_vpc_security_group_egress_rule" "endpoint_allow_all_traffic" {
  for_each = local.environments

  security_group_id = aws_security_group.endpoint_sg[each.key].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_security_group" "load_balancer_sg" {
  for_each = local.environments

  name        = "${each.key}_load_balancer_sg"
  description = "Manage load balancer sg for ${each.key}"
  vpc_id      = aws_vpc.vpc[each.key].id

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "lb_allow_tcp_80" {
  for_each = local.environments

  security_group_id = aws_security_group.load_balancer_sg[each.key].id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_vpc_security_group_egress_rule" "lb_allow_all_traffic" {
  for_each = local.environments

  security_group_id = aws_security_group.load_balancer_sg[each.key].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_security_group" "api_service_sg" {
  for_each = local.environments

  name        = "${each.key}_api_service_sg"
  description = "Manage api service sg for ${each.key}"
  vpc_id      = aws_vpc.vpc[each.key].id

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "api_service_allow_tcp_8080" {
  for_each = local.environments

  security_group_id = aws_security_group.api_service_sg[each.key].id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_vpc_security_group_egress_rule" "api_service_allow_all_traffic" {
  for_each = local.environments

  security_group_id = aws_security_group.api_service_sg[each.key].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_security_group" "app_service_sg" {
  for_each = local.environments

  name        = "${each.key}_app_service_sg"
  description = "Manage app service sg for ${each.key}"
  vpc_id      = aws_vpc.vpc[each.key].id

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "app_service_allow_tcp_8080" {
  for_each = local.environments

  security_group_id = aws_security_group.app_service_sg[each.key].id
  cidr_ipv4         = "10.0.0.0/16"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_vpc_security_group_egress_rule" "app_service_allow_all_traffic" {
  for_each = local.environments

  security_group_id = aws_security_group.app_service_sg[each.key].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}
