module "iam_execution_role" {
  source = "../../modules/iam-role"

  role_name        = "AppExecutionRole${title(var.environment)}"
  allowed_services = ["ecs-tasks.amazonaws.com"]
  policy           = data.aws_iam_policy_document.app.json
}

data aws_iam_policy_document "app" {
  statement {
    effect = "Allow"

    resources = [
      "*"
    ]

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:GetAuthorizationToken",
      "ecr:ListImages",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
  }

  statement {
    effect = "Allow"

    resources = ["*"]

    actions = [
      "ecr:GetAuthorizationToken"
    ]
  }

  statement {
    effect = "Allow"

    resources = ["*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }



}
