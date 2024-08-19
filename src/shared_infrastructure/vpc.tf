resource "aws_vpc" "vpc" {
  for_each = local.environments

  cidr_block = var.vpc_cidr

  tags = {
    Name        = "vpc_${each.key}"
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}
