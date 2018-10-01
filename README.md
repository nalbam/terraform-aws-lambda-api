# terraform-aws-lambda-api

## usage

```hcl
module "domain" {
  source = "git::https://github.com/nalbam/terraform-aws-route53.git"
  domain = "${var.domain}"
}

module "demo-api" {
  source = "git::https://github.com/nalbam/terraform-aws-lambda-api.git"
  region = "${var.region}"

  name = "demo"
  stage = "${var.stage}"
  description = "route53 > api gateway > lambda"
  runtime = "nodejs8.10"
  handler = "index.handler"
  memory_size = 512
  timeout = 5
  s3_bucket = "${var.bucket}"
  s3_key = "data/lambda-demo.zip"

  zone_id = "${module.domain.zone_id}"
  certificate_arn = "${module.domain.certificate_arn}"
  domain_name = "demo-api.${var.domain}"

  env_vars = {
    PROFILE = "${var.stage}"
  }
}
```
