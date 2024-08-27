resource "aws_resourcegroups_group" "resource_group" {
  for_each = local.environments

  name = "morphlow-${each.key}"
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
      "Values": [ "${each.key}" ]
    }
  ]
}
JSON
  }
}
