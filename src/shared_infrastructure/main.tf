locals {
  subnets = [
    {
      name              = "public_subnet_1",
      cidr_block        = "10.0.10.0/24",
      availability_zone = "us-east-1a"
    },
    {
      name              = "public_subnet_2",
      cidr_block        = "10.0.11.0/24",
      availability_zone = "us-east-1b"
    },
    {
      name              = "private_subnet_1",
      cidr_block        = "10.0.20.0/24",
      availability_zone = "us-east-1a"
    },
    {
      name              = "private_subnet_2",
      cidr_block        = "10.0.21.0/24",
      availability_zone = "us-east-1b"
    },
  ]

  environments = {
    qa = {
      subnets = local.subnets
    },
    dev = {
      subnets = local.subnets
    },
    stage = {
      subnets = local.subnets
    },
    prod = {
      subnets = local.subnets
    },
  }
}
