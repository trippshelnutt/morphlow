resource "aws_vpc" "vpc_dev" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "vpc_${var.env}"
    Project     = "morphlow"
    Environment = var.env
  }
}