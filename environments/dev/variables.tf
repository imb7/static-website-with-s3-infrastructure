# static_wbsite/environments/dev/variables.tf

# s3 bucket related variables
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "noncurrent_days" {
  description = "days after which noncurrent versions are deleted"
  type        = number
  default     = 30
}

variable "website_content_path" {
  description = "relative path website content"
  type        = string
  default     = "../../website-content" # should be relative to root module
}


# cloudfront related variables
variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for CloudFront"
  type        = string
}

variable "my_domain_names" {
  description = "my custom domain names"
  type        = list(string)
}


# provider related variables
variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1" # replace with specific region you want
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "StaticWebsiteHosting"
}

variable "owner" {
  description = "The owner of the resources"
  type        = string
  default     = "Ibrahim Bagwan"
}

variable "environment_name" {
  description = "The environment for the resources"
  type        = string
  default     = "dev"
}