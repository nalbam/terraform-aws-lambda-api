# Lambda Function : api gateway > lambda

module "lambda" {
  source = "github.com/nalbam/terraform-aws-lambda?ref=v0.12.1"
  region = var.region

  name        = var.name
  stage       = var.stage
  description = var.description
  runtime     = var.runtime
  handler     = var.handler
  memory_size = var.memory_size
  timeout     = var.timeout
  s3_bucket   = var.s3_bucket
  s3_source   = var.s3_source
  s3_key      = var.s3_key
  env_vars    = var.env_vars
}

resource "aws_lambda_permission" "default" {
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.arn
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowExecutionFromAPIGateway"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  //source_arn = "${aws_api_gateway_deployment.default.execution_arn}/${aws_api_gateway_method.default_get_req.http_method}${aws_api_gateway_resource.default.path}"
  //source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.default.id}/*/${aws_api_gateway_method.default.http_method}${aws_api_gateway_resource.default.path}"
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.default.id}/*/*"
}
