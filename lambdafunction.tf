

# resource "aws_iam_role" "lambda_cfs" {
#   name               = "lambda_cfs"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }



# resource "aws_lambda_function" "trigger_feedback" {
#   filename      = "CSFlambda.js"
#   function_name = "trigger_feedback"
#create role for lambda to communicate with aws resources
#   role = aws_iam_role.lambda_ocfs.arn
#   #Lambda function handler is a method in code that processes my lambda events
#   handler = "index.trigger"
#   source_code_hash = filebase64("${path.module}/lambda-code.zip")

#   timeout = 10
#   runtime = "nodejs16.x"
#   environment {
#     variables = {
#       db_table_name = "aws_dynamodb_table.feedbacktable.name"
#     }
#   }
#   provisioner "local-exec" {
#     command = "cd ${path.module}/Users/kimrah.bastien/Documents/OCFS/CSFlambda.js&& zip -r lambda-code.zip"
#   }
#   #  source_code_hash = filebase64("${path.module}/lambda-code.zip")

#   depends_on = [null_resource.create_zip]
# }
