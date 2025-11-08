# modules/cloudfront_distribution/outputs.tf

# Output the ARN of the CloudFront distribution for reference in other modules
output "distribution_arn" {
  description = "The ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.static_website_cdn.arn
}

# Output the domain name of the CloudFront distribution for easy access
output "distribution_domain_name" {
  description = "The domain name of the CloudFront distribution"
  value       = aws_cloudfront_distribution.static_website_cdn.domain_name
}