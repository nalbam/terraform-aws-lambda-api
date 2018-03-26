# terraform-aws-lambda-api

## usage
```
module "lambda-api" {
  source = "git::https://github.com/nalbam/terraform-aws-lambda-api.git"
  region = "ap-northeast-2"

  name = "demo"
  stage = "dev"
  runtime = "nodejs6.10"
  handler = "index.handler"
  memory_size = 512
  timeout = 5
  http_method = "GET"
  path_part = "demo"
  bucket = "bucket_name"
  package = "data/demo.zip"
}
```
