resource "aws_iam_role" "morphlow_task_role" {
  name = "morphlow-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Project = "morphlow"
  }
}

resource "aws_iam_role_policy_attachment" "task_power_users" {
  role       = aws_iam_role.morphlow_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role" "morphlow_execution_role" {
  name = "morphlow-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Project = "morphlow"
  }
}

resource "aws_iam_role_policy_attachment" "execution_power_users" {
  role       = aws_iam_role.morphlow_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role" "morphlow_codedeploy_role" {
  name = "morphlow-codedeploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codedeploy.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Project = "morphlow"
  }
}

resource "aws_iam_role_policy_attachment" "codedeploy_power_user" {
  role       = aws_iam_role.morphlow_codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}
