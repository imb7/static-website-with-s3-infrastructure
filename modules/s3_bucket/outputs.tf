# modules/s3/outputs.tf

# Output the bucket region-specific domain name
output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name"
  value       = aws_s3_bucket.static_website_bucket.bucket_regional_domain_name
}

# Output the bucket ARN
output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.static_website_bucket.arn
}

# Output the bucket ID (name)
output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.static_website_bucket.id
}