# dynamodb

resource "aws_dynamodb_table" "dynamodb" {
  count = var.dynamodb != "" ? 1 : 0

  name           = var.dynamodb
  read_capacity  = 10
  write_capacity = 10
  hash_key       = "id"

  # range_key = "title"

  attribute {
    name = "id"
    type = "S"
  }

  # attribute {
  #   name = "title"
  #   type = "S"
  # }

  #   ttl {
  #     attribute_name = "TimeToExist"
  #     enabled = false
  #   }

  #   global_secondary_index {
  #     name               = "GameTitleIndex"
  #     hash_key           = "GameTitle"
  #     range_key          = "TopScore"
  #     write_capacity     = 10
  #     read_capacity      = 10
  #     projection_type    = "INCLUDE"
  #     non_key_attributes = ["UserId"]
  #   }

  tags = {
    Name = "${var.stage}-${var.name}"
  }
}
