resource "aws_iam_role" "lambda_role" {
  name = "example_lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}
 
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_dynamodb_policy"
  description = "Allows Lambda to perform read and write operations on DynamoDB tables"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowDynamoDBReadWrite",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan"
      ],
      "Resource": "arn:aws:dynamodb:*:*:table/*"
    }
  ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "lambda_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_iam_role" "api_gateway_invoke_role" {
  name = "api_gateway_invoke_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execution_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.api_lambda_execution_policy.arn
}
resource "aws_iam_policy" "api_lambda_execution_policy" {
  name        = "api_lambda_execution_policy"
  description = "Policy for Lambda execution by API Gateway"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "lambda:InvokeFunction",
      "Resource": "arn:aws:lambda:us-east-1:452426097938:function:SendToDatabase"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "api_gateway_invoke_policy_attachment" {
  policy_arn = aws_iam_policy.api_lambda_execution_policy.arn  
  role       = aws_iam_role.api_gateway_invoke_role.name
}

resource "aws_iam_role_policy_attachment" "api_gateway_execution_policy_attachment" {
  role       = aws_iam_role.api_gateway_invoke_role.name
  policy_arn = aws_iam_policy.api_lambda_execution_policy.arn
}






