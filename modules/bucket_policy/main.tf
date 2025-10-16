resource "aws_s3_bucket_policy" "allow_cloudfront_policy" {
  bucket = var.bucket_id
  policy = data.aws_iam_policy_document.allow_cloudfront.json
}