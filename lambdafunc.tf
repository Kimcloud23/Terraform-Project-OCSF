# module "iam_roles" {
#   source = "../iam"
# }

# module "databaseCreation" {
#   source = "../database"
# }

# # Ensure changes to working files gets zipped to function folder
# data "archive_file" "lambda" {
#   type        = "zip"
#   source_file = "./modules/js/lambda_function.js"
#   output_path = "function.zip"
# }

# # Create and Deploy lamda function
# resource "aws_lambda_function" "trigger_feedback" {
#   function_name = "trigger_feedback"
#   runtime       = "nodejs14.x"
#   handler       = "lambda_function.handler"
#   filename      = "./modules/js/function.zip"
#   role          = module.iam_roles.lambda.arn
#   timeout       = 10
#   memory_size   = 128

#   depends_on = [ module.databaseCreation ]
# }

# output "func_feedback" {
#   value = aws_lambda_function.trigger_feedback
# }