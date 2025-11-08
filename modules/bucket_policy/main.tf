# Create an S3 bucket policy that allows CloudFront to access the bucket
# This policy uses the IAM policy document defined in data.tf

resource "aws_s3_bucket_policy" "allow_cloudfront_policy" {
  bucket = var.bucket_id
  policy = data.aws_iam_policy_document.allow_cloudfront.json
}