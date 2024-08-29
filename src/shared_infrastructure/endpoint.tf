locals {
  env_endpoints = flatten([
    for env_key, env in local.environments : {
      env_key         = env_key
      security_groups = [aws_security_group.endpoint_sg[env_key].id]
      subnets         = [for key, subnet in aws_subnet.private_subnet : subnet.id if startswith(key, env_key)]
    }
  ])
}

resource "aws_vpc_endpoint" "ecr_api" {
  for_each = tomap({
    for endpoint in local.env_endpoints : "${endpoint.env_key}" => endpoint
  })

  vpc_id            = aws_vpc.vpc[each.value.env_key].id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"

  subnet_ids = each.value.subnets

  security_group_ids = each.value.security_groups

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  for_each = tomap({
    for endpoint in local.env_endpoints : "${endpoint.env_key}" => endpoint
  })

  vpc_id            = aws_vpc.vpc[each.value.env_key].id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  subnet_ids = each.value.subnets

  security_group_ids = each.value.security_groups

  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "s3" {
  for_each = tomap({
    for endpoint in local.env_endpoints : "${endpoint.env_key}" => endpoint
  })

  vpc_id       = aws_vpc.vpc[each.value.env_key].id
  service_name = "com.amazonaws.${var.region}.s3"
}

