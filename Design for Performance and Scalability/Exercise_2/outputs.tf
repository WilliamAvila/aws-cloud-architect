# TODO: Define the output variable for the lambda function.
output "arn" {
  value       = aws_lambda_function.greet_lambda.arn
  description = "ARN for lambda function"
}
