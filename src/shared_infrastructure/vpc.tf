resource "aws_vpc" "vpc_dev" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "vpc_dev"
    Project     = "morphlow"
    Environment = "dev"
  }
}