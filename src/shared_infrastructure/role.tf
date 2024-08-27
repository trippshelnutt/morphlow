data "aws_iam_role" "morphlow_task_role" {
  name = "morphlow-task"
}

data "aws_iam_role" "morphlow_execution_role" {
  name = "morphlow-execution"
}

data "aws_iam_role" "morphlow_codedeploy_role" {
  name = "morphlow-codedeploy"
}
