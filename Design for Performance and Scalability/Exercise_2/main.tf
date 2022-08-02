terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.24.0"
    }
  }
}

provider "aws" {
  access_key = ""
  secret_key = ""
  token = ""
  profile = "default"
  region  = "us-east-1"
}
resource "aws_iam_role" "lambda_role" {
  name = "greet_lambda_function_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "iam_policy_lambda" {
  name        = "iam_policy_lambda_function"
  path        = "/"
  description = "IAM policy for logging"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "logs:CreateLogGroup",
        ],
        "Resource": "arn:aws:logs:*:*:*",
        "Effect": "Allow"
      },
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": [
          "arn:aws:logs:*:*:log-group:/aws/lambda/${var.lambda_name}:*"
        ]
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "attach_iam_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_lambda.arn
}

data "archive_file" "zip_lambda" {
  type        = "zip"
  source_file = "${path.module}/${var.lambda_name}.py"
  output_path = "${path.module}/${var.lambda_file}"
}

resource "aws_lambda_function" "greet_lambda" {
  role             = aws_iam_role.lambda_role.arn
  handler          = "${var.lambda_name}.${var.lambda_handler}"
  runtime          = var.lambda_runtime
  filename         = var.lambda_file
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy]
  function_name    = var.lambda_name

  environment {
    variables = {
      greeting = "Hello world"
    }
  }
}
