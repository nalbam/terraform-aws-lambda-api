# API Gateway : domain name

resource "aws_api_gateway_domain_name" "default" {
  domain_name = "${var.domain_name}"

  certificate_arn = "${var.certificate_arn}"
}

module "domain" {
  source = "git::https://gitlab.com/nalbam/terraform-aws-route53-alias.git"

  zone_id = "${var.zone_id}"
  name = "${var.domain_name}"
  alias_name = "${aws_api_gateway_domain_name.default.cloudfront_domain_name}"
  alias_zone_id = "${aws_api_gateway_domain_name.default.cloudfront_zone_id}"
}
