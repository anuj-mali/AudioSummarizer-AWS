module "transcriber" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "transcriber"
  handler       = "transcriber.handler"
  runtime       = "python3.13"
  source_path   = "src/transcriber.py"

  attach_policy = true

  policy = module.transcriber_policy.arn

  maximum_retry_attempts = 0

  environment_variables = {
    "OUTPUT_BUCKET" = aws_s3_bucket.audio.bucket
  }
}

module "summarizer" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "summarizer"
  handler       = "summarizer.handler"
  runtime       = "python3.13"
  timeout       = 90
  source_path   = "src/summarizer.py"

  attach_policy = true

  policy = module.summarizer_policy.arn

  maximum_retry_attempts = 0

  environment_variables = {
    "OUTPUT_BUCKET" = aws_s3_bucket.summary.bucket
  }
}
