# Terraform variables for the development environment

################################
# cloudfront related variables #
################################
acm_certificate_arn = "arn:aws:acm:us-east-1:557690614492:certificate/c7a224b6-5482-41ce-9503-92ed3c0de5db" # replace with your ACM certificate ARN in us-east-1
my_domain_names     = ["ibrahimbagwan.work", "www.ibrahimbagwan.work"]                                        # replace with your domain, subdomain names


###############################
# s3 bucket related variables #
###############################
noncurrent_days      = 30                      # number of days after which noncurrent version will be moved to next storage class
website_content_path = "../../website-content" # should be relative to root module


##############################
# provider related variables #
##############################
# Note: variables are used for interpolation in other resources like s3 bucket name, so choose names which follows s3 bucket naming conventions.
region           = "us-east-1" # replace with specific region you want
project_name     = "static-website"
owner            = "owner-name" # replace with resource owner name
environment_name = "dev"