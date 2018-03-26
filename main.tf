# Lambda Function : api gateway > lambda

module "lambda" {
  source = "git::https://github.com/nalbam/terraform-aws-lambda.git"
  region = "${var.region}"

  name = "${var.name}"
  stage = "${var.stage}"
  description = "${var.description}"
  runtime = "${var.runtime}"
  handler = "${var.handler}"
  memory_size = "${var.memory_size}"
  timeout = "${var.timeout}"
  s3_bucket = "${var.s3_bucket}"
  s3_key = "${var.s3_key}"
  env_vars = "${var.env_vars}"
}

resource "aws_api_gateway_rest_api" "default" {
  name = "${var.name}-${var.stage}"
}

resource "aws_api_gateway_resource" "default" {
  rest_api_id = "${aws_api_gateway_rest_api.default.id}"
  parent_id = "${aws_api_gateway_rest_api.default.root_resource_id}"
  path_part = "${var.path_part == "" ? var.name : var.path_part}"
}

resource "aws_api_gateway_method" "default" {
  rest_api_id = "${aws_api_gateway_rest_api.default.id}"
  resource_id = "${aws_api_gateway_resource.default.id}"
  http_method = "${var.http_method}"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "default" {
  type = "AWS_PROXY"
  rest_api_id = "${aws_api_gateway_rest_api.default.id}"
  resource_id = "${aws_api_gateway_resource.default.id}"
  http_method = "${aws_api_gateway_method.default.http_method}"
  uri = "${module.lambda.invoke_arn}"

  # AWS lambdas can only be invoked with the POST method
  integration_http_method = "POST"
}

resource "aws_api_gateway_deployment" "default" {
  rest_api_id = "${aws_api_gateway_rest_api.default.id}"
  stage_name = "${var.stage}"

  depends_on = [
    "aws_api_gateway_integration.default"
  ]
}

resource "aws_lambda_permission" "default" {
  action = "lambda:InvokeFunction"
  function_name = "${module.lambda.arn}"
  principal = "apigateway.amazonaws.com"
  statement_id = "AllowExecutionFromAPIGateway"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  //source_arn = "${aws_api_gateway_deployment.default.execution_arn}/${aws_api_gateway_method.default_get_req.http_method}${aws_api_gateway_resource.default.path}"
  //source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.default.id}/*/${aws_api_gateway_method.default.http_method}${aws_api_gateway_resource.default.path}"
  source_arn = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.default.id}/*/*"
}

# https://github.com/terraform-providers/terraform-provider-aws/issues/2195
resource "aws_api_gateway_domain_name" "default" {
  domain_name = "${var.domain_name}"
  certificate_arn = "${var.certificate_arn}"
}

resource "aws_api_gateway_base_path_mapping" "default" {
  api_id = "${aws_api_gateway_rest_api.default.id}"
  stage_name = "${aws_api_gateway_deployment.default.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.default.domain_name}"
}

module "domain" {
  source = "git::https://github.com/nalbam/terraform-aws-route53-alias.git"

  zone_id = "${var.zone_id}"
  name = "${var.domain_name}"
  alias_name = "${aws_api_gateway_domain_name.default.cloudfront_domain_name}"
  alias_zone_id = "${aws_api_gateway_domain_name.default.cloudfront_zone_id}"
}
