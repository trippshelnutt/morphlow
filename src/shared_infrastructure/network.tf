locals {
  env_public_subnets = flatten([
    for env_key, env in local.environments : [
      for subnet_key, subnet in env.public_subnets : {
        env_key           = env_key
        subnet_key        = subnet_key
        vpc_id            = aws_vpc.vpc[env_key].id
        cidr_block        = subnet.cidr_block
        name              = "${env_key}_${subnet.name}"
        availability_zone = subnet.availability_zone
      }
    ]
  ])

  env_private_subnets = flatten([
    for env_key, env in local.environments : [
      for subnet_key, subnet in env.private_subnets : {
        env_key           = env_key
        subnet_key        = subnet_key
        vpc_id            = aws_vpc.vpc[env_key].id
        cidr_block        = subnet.cidr_block
        name              = "${env_key}_${subnet.name}"
        availability_zone = subnet.availability_zone
      }
    ]
  ])
}

resource "aws_vpc" "vpc" {
  for_each = local.environments

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "vpc_${each.key}"
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_internet_gateway" "gateway" {
  for_each = local.environments

  vpc_id = aws_vpc.vpc[each.key].id

  tags = {
    Name        = "gateway_${each.key}"
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each = tomap({
    for subnet in local.env_public_subnets : "${subnet.env_key}.${subnet.subnet_key}" => subnet
  })

  vpc_id            = each.value.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name        = each.value.name
    Project     = "morphlow"
    Environment = each.value.env_key
  }
}

resource "aws_route_table" "public" {
  for_each = tomap({
    for subnet in local.env_public_subnets : "${subnet.env_key}.${subnet.subnet_key}" => subnet
  })

  vpc_id = aws_vpc.vpc[each.value.env_key].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway[each.value.env_key].id
  }

  tags = {
    Name        = "${each.key}_public_route_table"
    Project     = "morphlow"
    Environment = each.value.env_key
  }
}

resource "aws_route_table_association" "public" {
  for_each = tomap({
    for subnet in local.env_public_subnets : "${subnet.env_key}.${subnet.subnet_key}" => subnet
  })

  subnet_id      = aws_subnet.public_subnet[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_eip" "nat_eip" {
  for_each = tomap({
    for subnet in local.env_public_subnets : "${subnet.env_key}.${subnet.subnet_key}" => subnet
  })

  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  for_each = tomap({
    for subnet in local.env_public_subnets : "${subnet.env_key}.${subnet.subnet_key}" => subnet
  })

  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.public_subnet[each.key].id

  tags = {
    Name = "${each.value.name}_nat_gateway"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each = tomap({
    for subnet in local.env_private_subnets : "${subnet.env_key}.${subnet.subnet_key}" => subnet
  })

  vpc_id            = each.value.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name        = each.value.name
    Project     = "morphlow"
    Environment = each.value.env_key
  }
}

resource "aws_route_table" "private" {
  for_each = tomap({
    for subnet in local.env_public_subnets : "${subnet.env_key}.${subnet.subnet_key}" => subnet
  })

  vpc_id = aws_vpc.vpc[each.value.env_key].id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }

  tags = {
    Name        = "${each.key}_private_route_table"
    Project     = "morphlow"
    Environment = each.value.env_key
  }
}

resource "aws_route_table_association" "private" {
  for_each = tomap({
    for subnet in local.env_private_subnets : "${subnet.env_key}.${subnet.subnet_key}" => subnet
  })

  subnet_id      = aws_subnet.private_subnet[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_security_group" "security_group" {
  for_each = local.environments

  name        = "${each.key}_security_group"
  description = "Manage the security group for the ${each.key} environment"
  vpc_id      = aws_vpc.vpc[each.key].id

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  for_each = local.environments

  security_group_id = aws_security_group.security_group[each.key].id
  cidr_ipv4         = aws_vpc.vpc[each.key].cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  for_each = local.environments

  security_group_id = aws_security_group.security_group[each.key].id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}
