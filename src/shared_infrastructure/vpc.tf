resource "aws_vpc" "vpc" {
  for_each = local.environments

  cidr_block = var.vpc_cidr

  tags = {
    Project     = "morphlow"
    Environment = "${each.key}"
  }
}
