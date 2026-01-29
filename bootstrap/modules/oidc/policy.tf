resource "aws_iam_policy" "permissions" {
  name = "${var.role_name}-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = var.allowed_actions   //Actions specify what operations your role can perform.
        Resource = "*"              //Resource defines which specific resource objects your role can access
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.permissions.arn
}
  // this policy attached to the github-actions-oidc-role role allows it to perform the actions defined in the allowed_actions variable.