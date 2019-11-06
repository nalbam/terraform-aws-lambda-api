# output

output "arn" {
  value = module.lambda.arn
}

output "invoke_arn" {
  value = module.lambda.invoke_arn
}

output "invoke_url" {
  value = aws_api_gateway_deployment.default.invoke_url
}

output "domain" {
  value = var.domain_name
}
