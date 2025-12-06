# S3 Bucket Outputs
output "audio_bucket_name" {
  value = aws_s3_bucket.audio.bucket
}

output "summary_bucket_name" {
  value = aws_s3_bucket.summary.bucket
}

# Lambda Outputs
output "transcriber_lambda_arn" {
  value = module.transcriber.lambda_function_arn
}

output "summarizer_lambda_arn" {
  value = module.summarizer.lambda_function_arn
}
