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
