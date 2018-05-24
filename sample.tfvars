name = "demo"
stage = "dev"

runtime = "nodejs6.10"
handler = "index.handler"

s3_bucket = "sample"
s3_key = "sample"

zone_id = "sample"
domain_name = "sample"
certificate_arn = "sample"

env_vars = {
  SAMPLE = "sample"
}

methods = [
  {
    http_method = "GET"
    path_part = "demos"
  },
  {
    http_method = "GET"
    path_part = "demos/{id}"
  },
  {
    http_method = "POST"
    path_part = "demos"
  }
]
