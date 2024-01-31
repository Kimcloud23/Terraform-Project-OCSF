#Presentation Layer
resource "aws_s3_bucket" "onlinecustomerfbsurvey" {
  bucket = "onlinecustomerfbsurvey"
  tags = {
    Name = "CustomerFeedback"
  }
}
resource "aws_s3_bucket_ownership_controls" "ObjectWriter" {
  bucket = aws_s3_bucket.onlinecustomerfbsurvey.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.onlinecustomerfbsurvey.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "public-read" {
  depends_on = [
    aws_s3_bucket_ownership_controls.ObjectWriter,
    aws_s3_bucket_public_access_block.public_access_block,
  ]

  bucket = aws_s3_bucket.onlinecustomerfbsurvey.id
  acl    = "public-read"

}


resource "aws_s3_object" "html_file" {
  bucket = aws_s3_bucket.onlinecustomerfbsurvey.id
  key    = "feedbackform.html"
  source = "feedbackform.html"
  acl    = "public-read"
  content_type = "text/html"
}
  
resource "aws_s3_bucket_website_configuration" "customer_survey" {
  bucket = aws_s3_bucket.onlinecustomerfbsurvey.id

  index_document {
    suffix = "feedbackform.html"
  }
  error_document {
    key = "error.html"
  }
}

# Application tier will use Lambda to submit and process feedback to the database

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.js"
  output_path = "function.zip"
}
# resource "aws_lambda_invocation" "invoke_lambda" {
#   function_name = aws_lambda_function.trigger_feedback.function_name
#   input = jsonencode({
#     name = "Kimrah Bastien"
#     Email = "kimrah.bastien@ahead.com"
#     feedback = "This is a test"
#   })
  
# }
resource "aws_lambda_function" "trigger_feedback" {
  function_name    = "trigger_feedback"
  runtime          = "nodejs14.x"
  handler          = "lambda_function.handler"
  filename         = "function.zip"
  role             = aws_iam_role.lambda_role.arn
  timeout = 10
  memory_size = 128

    environment {
    variables = {
      db_table_name = "FeedbackTable"
      DB_HOST       = aws_db_instance.cffdb.address
      DB_USER       = aws_db_instance.cffdb.username
      DB_PASS       = aws_db_instance.cffdb.password
    }
    
  }
  # ensures that my database is created before my lambda function
  depends_on = [
    aws_iam_role_policy_attachment.lambda_attachment,
    aws_dynamodb_table.feedbacktable,
    aws_db_instance.cffdb,
  ]
}

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
    Name        = "dynamodb-table-cff"
    Environment = "production"
  }
}

resource "aws_db_instance" "cffdb" {
  allocated_storage    = 10
  db_name              = "cffdb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "KimPossible"
  password             = "TerraformGuru23"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

# resource "aws_db_parameter_group" "rds-pg" {
#   name   = "rds-pg"
#   family = "mysql5.7"

#   parameter {
#     name  = "character_set_server"
#     value = "utf8"
#   }

#   parameter {
#     name  = "character_set_client"
#     value = "utf8"
#   }
# }
