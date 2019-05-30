// cognito

resource "aws_cognito_user_pool" "default" {
  count = var.user_pool_name != "" ? 1 : 0

  name = var.user_pool_name
}

resource "aws_api_gateway_authorizer" "default" {
  count = var.user_pool_name != "" ? 1 : 0

  name = "${var.stage}-${var.name}-cognito"
  type = "COGNITO_USER_POOLS"

  rest_api_id = aws_api_gateway_rest_api.default.id

  provider_arns = [
    aws_cognito_user_pool.default[0].arn,
  ]
}
