# Terraform variables for the development environment

# cloudfront related variables
acm_certificate_arn = "acm_certificate_arn_value"           # replace with your ACM certificate ARN in us-east-1
my_domain_names     = ["example.com", "www.example.com"]    # replace with your domain names


#s3 bucket related variables
noncurrent_days      = 30                               # number of days after which noncurrent version will be moved to next storage class
website_content_path = "../../website-content"          # should be relative to root module