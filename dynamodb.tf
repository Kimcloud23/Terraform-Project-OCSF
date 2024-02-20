# Database tier will use dynamodb to store feedback
resource "aws_dynamodb_table" "feedbacktable" {
  name         = "FeedbackTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "Name"
  range_key    = "FEEDBACKDB"

  attribute {
    name = "Name"
    type = "S"
  }

  attribute {
    name = "FEEDBACKDB"
    type = "S"
  }

  attribute {
    name = "Email"
    type = "S"
  }
  attribute {
    name = "Feedback"
    type = "S"
  }


  global_secondary_index {
    name               = "FEEDBACKDBIndex"
    hash_key           = "Email"
    range_key          = "Feedback"
    projection_type    = "INCLUDE"
    non_key_attributes = ["Name"]
  }

  tags = {
    Name        = "dynamodb-table-feedbackdb"
    Environment = "production"
  }
}