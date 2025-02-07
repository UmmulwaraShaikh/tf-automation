resource "aws_iam_policy" "ec2_policy" {
  name        = "${var.cloud_env}_ec2_policy"
  path        = "/"
  description = "Policy to provide permission to EC2"
  # Terraform's "jsonencode" function converts a Terraform expression result to

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
"ec2:Describe*",
"s3:Get*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "ec2_role" {
  name = "${var.cloud_env}_ec2_role"
  assume_role_policy = "${file("assumerolepolicy.json")}"
}
resource "aws_iam_role_policy_attachment" "ec2_policy_role" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.cloud_env}_ec2_role"
  role = aws_iam_role.ec2_role.name
}
