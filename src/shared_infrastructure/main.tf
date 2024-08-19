resource "aws_resourcegroups_group" "resource_group" {
  name = "morphlow-${var.env}"
  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    {
      "Key": "Project",
      "Values": [ "morphlow" ]
    },
    {
      "Key": "Environment",
      "Values": [ "${var.env}" ]
    }
  ]
}
JSON
  }
}

# resource "aws_ecs_cluster" "cluster" {
#   name = "morphlow_ecs_cluster"

#   setting {
#     name  = "containerInsights"
#     value = "disabled"
#   }

#   tags = {
#     Name    = "cluster"
#     Project = "morphlow"
#   }
# }

# resource "aws_ecs_capacity_providers" "cluster" {
#   cluster_name = aws_ecs_cluster.cluster.name

#   capacity_providers = ["FARGATE_SPOT", "FARGATE"]
#   default_capacity_provider_strategy {
#     capacity_provider = "FARGATE_SPOT"
#   }

#   tags = {
#     Name    = "cluster"
#     Project = "morphlow"
#   }
# }

# module "ecs-fargate" {
#   source  = "umotif-public/ecs-fargate/aws"
#   version = "~> 8.0"

#   name_prefix        = "ecs-fargate-example"
#   vpc_id             = aws_vpc.ecs_vpc.id
#   private_subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

#   cluster_id = aws_ecs_cluster.cluster.id

#   task_container_image   = "centos"
#   task_definition_cpu    = 256
#   task_definition_memory = 512

#   task_container_port             = 80
#   task_container_assign_public_ip = true

#   load_balanced = true

#   target_groups = [
#     {
#       target_group_name = "tg-fargate-example"
#       container_port    = 80
#     }
#   ]

#   health_check = {
#     port = "traffic-port"
#     path = "/"
#   }

#   tags = {
#     Environment = "dev"
#     Project     = "morphlow"
#   }
# }
