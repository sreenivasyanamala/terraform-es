resource "aws_cloudwatch_log_group" "es_cloudwatch" {
  name = "${var.domain_name}-log-g"
  tags = var.tags
}

resource "aws_cloudwatch_log_resource_policy" "es_aws_cloudwatch_log-policy" {
  policy_name = "${var.domain_name}-p"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
}

# Service-linked role to give Amazon ES permissions to access your VPC
resource "aws_iam_service_linked_role" "access-to-vpc" {
  count            = var.create_service_link_role == true ? 1 : 0
  aws_service_name = "es.amazonaws.com"
  description      = "Service-linked role to give Amazon ES permissions to access your VPC"
}
