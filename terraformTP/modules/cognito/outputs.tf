output "user_pool_arn" {
  description = "Cognito User Pool ARN"
  value = aws_cognito_user_pool.pool.arn
}

output "client_ids" {
  description = "Cognito Client IDs"
  value = aws_cognito_user_pool_client.client[*].id
}