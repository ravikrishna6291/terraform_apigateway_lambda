terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.72.0"
    }
  }
}

# Provider details
provider "aws" {
  profile = var.profile
  region  = var.aws_region
}

# Creating API Gateway and assigning the name
resource "aws_api_gateway_rest_api" "this" {
  name        = var.api_name
  description = "${var.api_name} REST API"
    endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Creating authorizer
resource "aws_api_gateway_authorizer" "this" {
  name           = "authorizer"
  rest_api_id    = aws_api_gateway_rest_api.this.id
  authorizer_uri = aws_lambda_function.authorizer.invoke_arn
}

# Creating resource in API Gateway
resource "aws_api_gateway_resource" "bouncer" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "bouncer"
}

# Creating method in API Gateway
resource "aws_api_gateway_resource" "bouncer_proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.bouncer.id
  path_part   = "{proxy+}"
}



# Selecting Custom method in API Gateway
resource "aws_api_gateway_method" "bouncer_method" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.bouncer_proxy.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.this.id

}

resource "aws_api_gateway_integration" "bouncer_integration" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.bouncer_proxy.id
  http_method             = aws_api_gateway_method.bouncer_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.bouncer.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda_bouncer" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "bouncer"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*/*"
}

# Creating resource in API Gateway
resource "aws_api_gateway_resource" "registration" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "registration"
}

# Creating method in API Gateway
resource "aws_api_gateway_resource" "registration_proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.registration.id
  path_part   = "{proxy+}"
}



# Selecting Custom method in API Gateway
resource "aws_api_gateway_method" "registration_method" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.registration_proxy.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.this.id

}

resource "aws_api_gateway_integration" "registration_integration" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.registration_proxy.id
  http_method             = aws_api_gateway_method.registration_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.registration.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda_registration" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "registration"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*/*"
}

# Creating resource in API Gateway
resource "aws_api_gateway_resource" "testexec" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "testexec"
}

# Creating method in API Gateway
resource "aws_api_gateway_resource" "testexec_proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.testexec.id
  path_part   = "{proxy+}"
}



# Selecting Custom method in API Gateway
resource "aws_api_gateway_method" "testexec_method" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.testexec_proxy.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.this.id

}

resource "aws_api_gateway_integration" "testexec_integration" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.testexec_proxy.id
  http_method             = aws_api_gateway_method.testexec_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.testexec.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda_testexec" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "testexec"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*/*"
}

# Creating resource in API Gateway
resource "aws_api_gateway_resource" "testreport" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "testreport"
}

# Creating method in API Gateway
resource "aws_api_gateway_resource" "testreport_proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.testreport.id
  path_part   = "{proxy+}"
}



# Selecting Custom method in API Gateway
resource "aws_api_gateway_method" "testreport_method" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.testreport_proxy.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.this.id

}

resource "aws_api_gateway_integration" "testreport_integration" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.testreport_proxy.id
  http_method             = aws_api_gateway_method.testreport_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.testreport.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda_testreport" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "testreport"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*/*"
}

# Deploying API
resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.api_stage_name
}


resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_api_gateway_method.bouncer_method,aws_api_gateway_integration.bouncer_integration,
    aws_api_gateway_method.registration_method,aws_api_gateway_integration.registration_integration,
    aws_api_gateway_method.testexec_method,aws_api_gateway_integration.testexec_integration,
    aws_api_gateway_method.testreport_method,aws_api_gateway_integration.testreport_integration
  ]
}


resource "aws_lambda_function" "authorizer" {
  filename      = "lambda-authorizer.zip"
  function_name = "authorizer"
  role          = aws_iam_role.iam_role_for_lambda.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"
}


resource "aws_lambda_function" "bouncer" {
  filename      = "lambda_code.zip"
  function_name = "bouncer"
  role          = aws_iam_role.iam_role_for_lambda.arn
  handler       = "LambdaFunctionOverHttps.handler"
  runtime       = "python3.9"
}

resource "aws_lambda_function" "registration" {
  filename      = "lambda_code.zip"
  function_name = "registration"
  role          = aws_iam_role.iam_role_for_lambda.arn
  handler       = "LambdaFunctionOverHttps.handler"
  runtime       = "python3.9"
}

resource "aws_lambda_function" "testexec" {
  filename      = "lambda_code.zip"
  function_name = "testexec"
  role          = aws_iam_role.iam_role_for_lambda.arn
  handler       = "LambdaFunctionOverHttps.handler"
  runtime       = "python3.9"
}

resource "aws_lambda_function" "testreport" {
  filename      = "lambda_code.zip"
  function_name = "testreport"
  role          = aws_iam_role.iam_role_for_lambda.arn
  handler       = "LambdaFunctionOverHttps.handler"
  runtime       = "python3.9"
  layers = [aws_lambda_layer_version.lambda_layer.arn]
}

resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = "layer.zip"
  layer_name = "lambda_layer_name"
  compatible_runtimes = ["python3.8","python3.9"]
}

resource "aws_iam_role" "iam_role_for_lambda" {
name = "iam_role_for_lambda_terraform"
assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
]
}
EOF
}
