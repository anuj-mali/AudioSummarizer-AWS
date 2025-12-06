resource "aws_s3_bucket" "audio" {
  bucket_prefix = "audio-bucket-"
  force_destroy = true
}

resource "aws_s3_bucket" "summary" {
  bucket_prefix = "summary-bucket-"
  force_destroy = true
}

module "audio_bucket_notification" {
  source = "terraform-aws-modules/s3-bucket/aws//modules/notification"

  bucket = aws_s3_bucket.audio.bucket

  lambda_notifications = [
    {
      function_arn  = module.transcriber.lambda_function_arn
      function_name = module.transcriber.lambda_function_name
      events = [
        "s3:ObjectCreated:*"
      ]
      filter_prefix = "audio/"
      filter_suffix = ".mp3"
    },
    {
      function_arn  = module.summarizer.lambda_function_arn
      function_name = module.summarizer.lambda_function_name
      events = [
        "s3:ObjectCreated:*"
      ]
      filter_prefix = "transcription/"
      filter_suffix = ".json"
    }
  ]

}