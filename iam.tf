module "transcriber_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "TranscriberPolicy"
  path        = "/"
  description = "Policy for Transcriber"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllowS3Access",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.audio.arn}",
          "${aws_s3_bucket.audio.arn}/*"
        ]
        }, {
        "Sid" : "AllowTranscribeAccess",
        "Effect" : "Allow",
        "Action" : [
          "transcribe:StartTranscriptionJob"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}

module "summarizer_policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "SummarizerPolicy"
  path        = "/"
  description = "Policy for Summarizer"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ReadAudioBucket",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket",
          "s3:GetObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.audio.arn}",
          "${aws_s3_bucket.audio.arn}/*"
        ]
      },
      {
        "Sid" : "WriteSummaryBucket",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.summary.arn}",
          "${aws_s3_bucket.summary.arn}/*"
        ]
      },
      {
        "Sid" : "AllowBedrockAccess",
        "Effect" : "Allow",
        "Action" : [
          "bedrock:InvokeModel",
          "aws-marketplace:ViewSubscriptions",
          "aws-marketplace:Subscribe"
        ],
        "Resource" : [
          "*"
        ]
      }
    ]
  })
}