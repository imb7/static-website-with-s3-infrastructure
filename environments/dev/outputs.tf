# Development environment outputs

# Output the CloudFront distribution ARN
output "distribution_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = module.cloudfront_distribution.distribution_domain_name
}

# Output the S3 bucket name
output "s3_bucket_name" {
  description = "The name of the S3 bucket hosting the website"
  value       = module.s3_bucket.bucket_id
}