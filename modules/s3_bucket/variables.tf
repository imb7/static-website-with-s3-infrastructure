# Values will be retrieved from variables defined in root modules terraform.tfvars
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