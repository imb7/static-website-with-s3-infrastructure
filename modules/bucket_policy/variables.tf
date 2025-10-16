# Value will be retrieved from output of cloudfront_distribution module => root module's module composition
variable "cloudfront_distribution_arn" {
  description = "ARN of the CloudFront distribution allowed to access bucket"
  type        = string
}

# Value will be retrieved from output of s3_bucket module => root module's module composition
variable "bucket_id" {
  description = "ID of the S3 bucket to attach the policy to"
  type        = string
}

variable "bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}