# modules/cloudfront_distribution/main.tf

resource "aws_cloudfront_origin_access_control" "oac_s3_bucket" {
  name                              = "static-website-oac"
  description                       = "OAC for static website S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "static_website_cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for static website"
  price_class         = "PriceClass_All"
  default_root_object = "index.html"

  # Add your custom domain names here
  aliases = var.my_domain_names

  origin {
    domain_name              = var.bucket_regional_domain_name
    origin_id                = "S3-${var.bucket_id}" # Creating unique ID for the origin using combination of bucket name and prefix
    origin_access_control_id = aws_cloudfront_origin_access_control.oac_s3_bucket.id
  }

  # cache behavior decides what to do when request comes
  default_cache_behavior {
    target_origin_id       = "S3-${var.bucket_id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  # Custom error responses for friendly error handling
  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/404.html" # Your custom 404 error page
    error_caching_min_ttl = 300         # Cache error response for 5 minutes
  }

  custom_error_response {
    error_code            = 403
    response_code         = 404
    response_page_path    = "/404.html" # Map 403 forbidden to same custom 404 page
    error_caching_min_ttl = 300
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Viewer certificate configuration for HTTPS with ACM
  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
