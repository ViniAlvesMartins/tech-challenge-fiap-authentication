provider "aws" {
  region  = "us-east-1"
  # if you run terraform locally then you will need to replace this with your credentials/aws-profile
  # and if you want to run through Github actions then you need to configure Secrets into Github
  # profile = "aws-profile" 
}

data "archive_file" "lambda_terraform_test" {
  type = "zip"

  source_dir  = "${path.module}/terraform_test"
  output_path = "${path.module}/terraform_test.zip"
}

# to Create function
resource "aws_lambda_function" "terraform_test" {
  function_name = "lbd-authentication"
  filename      = "terraform_test.zip"
  runtime = "nodejs18.x"
  handler = "index.handler"
  source_code_hash = data.archive_file.lambda_terraform_test.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "terraform_test" {
  name = "/aws/lambda/terraform_test"
  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_test_lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}