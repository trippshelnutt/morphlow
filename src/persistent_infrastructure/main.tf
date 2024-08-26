locals {
  public_subnets = [
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
  ]
  private_subnets = [
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
      public_subnets  = local.public_subnets
      private_subnets = local.private_subnets
    },
    # dev = {
    #   public_subnets  = local.public_subnets
    #   private_subnets = local.private_subnets
    # },
    # stage = {
    #   public_subnets  = local.public_subnets
    #   private_subnets = local.private_subnets
    # },
    # prod = {
    #   public_subnets  = local.public_subnets
    #   private_subnets = local.private_subnets
    # },
  }
}
