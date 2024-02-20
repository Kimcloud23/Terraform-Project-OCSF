
# API gateway v2 resources are used for creating and deploying Websocket and HTTP APIs 
resource "aws_apigatewayv2_api" "feedback_api" {
  name                       = "feedback_api"
  protocol_type              = "HTTP"

cors_configuration {
  allow_origins = ["*"]
    allow_methods = ["GET", "POST"]
    allow_headers = ["*"]
    expose_headers = ["*"]
    max_age       = 3600
  } 
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.feedback_api.id
  integration_type = "AWS_PROXY"
  description = "Lambda integration"
  integration_method = "POST"
  connection_type = "INTERNET"
  integration_uri  = aws_lambda_function.trigger_feedback.invoke_arn
  depends_on = [ aws_lambda_function.trigger_feedback ]
  }

resource "aws_apigatewayv2_route" "feedback_route" {
  api_id    = aws_apigatewayv2_api.feedback_api.id
  route_key = "POST /feedback_route"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "feedback_stage" {
  api_id = aws_apigatewayv2_api.feedback_api.id
  name   = "prod"
  auto_deploy = true
}
resource "aws_lambda_permission" "lambda_permission" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "trigger_feedback"
  principal = "apigateway.amazonaws.com"
  source_arn = aws_apigatewayv2_api.feedback_api.execution_arn
  depends_on = [ aws_lambda_function.trigger_feedback ]
  
}






















