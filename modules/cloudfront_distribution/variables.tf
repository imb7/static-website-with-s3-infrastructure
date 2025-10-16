# Value will be retrieved from output of s3_bucket module => root module's module composition
variable "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  type        = string
}

variable "bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}

variable "bucket_id" {
  description = "ID of the S3 bucket"
  type        = string
}


# Values will be retrieved from variables defined in root modules terraform.tfvars
variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for CloudFront"
  type        = string
}

variable "my_domain_names" {
  description = "my custom domain names"
  type        = list(string)
}