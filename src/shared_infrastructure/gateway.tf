resource "aws_internet_gateway" "gateway" {
  for_each = local.environments

  vpc_id = aws_vpc.vpc[each.key].id

  tags = {
    Name        = "gateway_${each.key}"
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}
