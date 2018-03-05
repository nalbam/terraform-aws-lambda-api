# API Gateway : domain name

resource "aws_api_gateway_domain_name" "default" {
  domain_name = "${var.domain_name}"
  certificate_arn = "${var.certificate_arn}"
}
