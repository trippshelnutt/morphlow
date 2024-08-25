locals {
  all_subnets = flatten([
    for env_key, env in local.environments : [
      for subnet_key, subnet in env.subnets : {
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

resource "aws_subnet" "subnet" {
  for_each = tomap({
    for subnet in local.all_subnets : "${subnet.env_key}.${subnet.subnet_key}" => subnet
  })

  vpc_id            = each.value.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Project     = "morphlow"
    Environment = each.value.env_key
  }
}
