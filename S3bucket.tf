# # Create and Deploy S3 bucket
# resource "aws_s3_bucket" "onlinecustomerfbsurvey" {
#   bucket = "onlinecustomerfbsurvey"
#   tags = {
#     Name = "CustomerFeedback"
#   }

# }

# # Collecting s3 bucket {id} into a local variable
# data "aws_s3_bucket" "onlinecustomerfbsurvey" {
#     bucket = "onlinecustomerfbsurvey"

#     depends_on = [aws_s3_bucket.onlinecustomerfbsurvey]
# }

# locals {
#   bucket_id = data.aws_s3_bucket.onlinecustomerfbsurvey.id
# }

# # S3 Bucket permissions and ACL configuration
# resource "aws_s3_bucket_ownership_controls" "ObjectWriter" {
#   bucket = local.bucket_id
#   rule {
#     object_ownership = "ObjectWriter"
#   }
# }

# resource "aws_s3_bucket_public_access_block" "public_access_block" {
#   bucket = local.bucket_id

#   block_public_acls       = false
#   block_public_policy     = false
#   ignore_public_acls      = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_acl" "public-read" {
#   depends_on = [
#     aws_s3_bucket_ownership_controls.ObjectWriter,
#     aws_s3_bucket_public_access_block.public_access_block,
#   ]

#   bucket = local.bucket_id
#   acl    = "public-read"

# }

# #Upload html file to S3 bucket
# resource "aws_s3_object" "html_file" {
#   bucket       = local.bucket_id
#   key          = "feedbackform.html"
#   source       = "feedbackform.html"
#   acl          = "public-read"
#   content_type = "text/html"

#   depends_on = [ aws_s3_bucket_acl.public-read, aws_s3_bucket_public_access_block.public_access_block ]
# }

# resource "aws_s3_bucket_website_configuration" "onlinecustomerfbsurvey" {
#   bucket = local.bucket_id

#   index_document {
#     suffix = "feedbackform.html"
#   }
#   error_document {
#     key = "error.html"
#   }
# }