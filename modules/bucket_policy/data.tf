# creates policy document to allow cloudfront to access s3 bucket
data "aws_iam_policy_document" "allow_cloudfront" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${var.bucket_arn}/*" # The S3 bucket ARN with /* to cover all objects
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        var.cloudfront_distribution_arn # The ARN of the CloudFront distribution
      ]
    }
  }
}