resource "aws_subnet" "private_subnet_1" {
  for_each = local.environments

  vpc_id            = aws_vpc.vpc[each.key].id
  cidr_block        = each.value.subnet_ips[0]
  availability_zone = "us-east-1a"

  tags = {
    Name        = "${each.key}_private_subnet_1"
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}


resource "aws_subnet" "private_subnet_2" {
  for_each = local.environments

  vpc_id            = aws_vpc.vpc[each.key].id
  cidr_block        = each.value.subnet_ips[1]
  availability_zone = "us-east-1b"

  tags = {
    Name        = "${each.key}_private_subnet_2"
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}
