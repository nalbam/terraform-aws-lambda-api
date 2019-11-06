# route53

# https://github.com/terraform-providers/terraform-provider-aws/issues/2195
resource "aws_api_gateway_domain_name" "default" {
  count = var.domain_name != "" ? 1 : 0

  domain_name     = var.domain_name
  certificate_arn = var.certificate_arn
}

resource "aws_api_gateway_base_path_mapping" "default" {
  count = var.domain_name != "" ? 1 : 0

  api_id      = aws_api_gateway_rest_api.default.id
  stage_name  = aws_api_gateway_deployment.default.stage_name
  domain_name = aws_api_gateway_domain_name.default[0].domain_name
}

resource "aws_route53_record" "default" {
  count = var.domain_name != "" ? 1 : 0

  zone_id = var.zone_id

  name = var.domain_name
  type = "A"

  alias {
    name                   = aws_api_gateway_domain_name.default[0].cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.default[0].cloudfront_zone_id
    evaluate_target_health = "false"
  }
}
