module "s3_bucket" {
  source = "../../modules/s3_bucket"

  # provides necessary variables for s3_bucket module
  bucket_name          = var.bucket_name
  noncurrent_days      = var.noncurrent_days
  website_content_path = var.website_content_path
}


module "cloudfront_distribution" {
  source = "../../modules/cloudfront_distribution"

  # provides necessary variables for cloudfront_distribution module
  acm_certificate_arn = var.acm_certificate_arn
  my_domain_names     = var.my_domain_names

  # Provide the necessary variables from the output of s3_bucket module
  bucket_regional_domain_name = module.s3_bucket.bucket_regional_domain_name
  bucket_arn                  = module.s3_bucket.bucket_arn
  bucket_id                   = module.s3_bucket.bucket_id
}


module "bucket_policy" {
  source = "../../modules/bucket_policy"

  # Provide the necessary variables from the output of s3_bucket module
  bucket_id  = module.s3_bucket.bucket_id
  bucket_arn = module.s3_bucket.bucket_arn

  # Provide the necessary variables from the output of cloudfront_distribution module
  cloudfront_distribution_arn = module.cloudfront_distribution.distribution_arn

}