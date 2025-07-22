resource "aws_iam_role" "this" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = var.allowed_services
        }
      },
    ]
  })
  force_detach_policies = true
}

resource "aws_iam_policy" "this" {
  name   = var.role_name
  path   = "/"
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

output "out-iam-role" {
  value = aws_iam_role.this
}
