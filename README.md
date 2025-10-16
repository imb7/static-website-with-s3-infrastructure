# Static Website with S3 Infrastructure

Terraform configuration for securely hosting a static website on AWS S3, featuring blocked public access, CloudFront integration for CDN, and automated deployment of site content. This solution is ideal for scalable, secure, and cost-effective static site hosting.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Customization](#customization)
- [Usage](#usage)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Cleanup](#cleanup)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Overview

This project provides Terraform code to provision a secure, production-ready static website hosting environment on AWS. It leverages S3 for storage and CloudFront for CDN and HTTPS.  
**Note:** This configuration assumes you already have:
- An ACM certificate (for your domain) in `us-east-1`
- A registered domain (e.g., from GoDaddy)
- DNS management handled outside of AWS Route 53 (e.g., via your registrar)

IAM and Route 53 resources are **not** managed by this project.

## Architecture

- **Amazon S3**: Stores static website files (HTML, CSS, JS, images). Public access is blocked.
- **CloudFront**: Distributes content globally, provides HTTPS, and restricts direct S3 access.
- **ACM Certificate**: You provide an existing AWS ACM certificate for your domain (must be in `us-east-1`).
- **Domain Name**: You provide a registered domain (e.g., from GoDaddy).
- **DNS**: You must manually configure your DNS provider to point your domain to the CloudFront distribution.

```
[User] ---> [CloudFront CDN] ---> [S3 Bucket (private)]
```

## Features

- **Private S3 bucket**: All public access is blocked for security.
- **CloudFront distribution**: Serves content securely over HTTPS and caches globally.
- **Custom domain and SSL**: Supports your own domain and SSL certificate.
- **Automated deployment**: Easily upload and update site content using AWS CLI or scripts.
- **Infrastructure as Code**: All resources are managed and reproducible via Terraform.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.0 or newer
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- An AWS account with permissions to manage S3 and CloudFront
- **Existing ACM certificate** in `us-east-1` for your domain
- **Registered domain name** (e.g., from GoDaddy)
- Ability to update DNS records at your registrar

## Customization

Before deploying, you **must** update the following values to match your environment and requirements:

| Variable                | Description                                                                 | Example Value                | Where to Set                |
|-------------------------|-----------------------------------------------------------------------------|------------------------------|-----------------------------|
| `bucket_name`           | Globally unique S3 bucket name for your site                               | `my-unique-site-bucket`      | `terraform.tfvars` or CLI   |
| `region`                | AWS region for S3 bucket (e.g., `us-east-1`)                               | `us-east-1`                  | `terraform.tfvars` or CLI   |
| `domain_name`           | Your custom domain (must match ACM cert)                                   | `www.example.com`            | `terraform.tfvars` or CLI   |
| `acm_certificate_arn`   | ARN of your ACM certificate (must be in `us-east-1` for CloudFront)        | `arn:aws:acm:us-east-1:...`  | `terraform.tfvars` or CLI   |
| `site_directory`        | Local directory containing your static site files                           | `./site`                     | Deployment step             |

**You must also:**
- Ensure your ACM certificate is validated and issued for your domain.
- Update your DNS provider (e.g., GoDaddy) to point your domain's CNAME or A record to the CloudFront distribution domain after deployment.

## Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/imb7/static-website-with-s3-infrastructure.git
   cd static-website-with-s3-infrastructure
   ```

2. **Customize variables:**
   - Edit `terraform.tfvars` or set variables via CLI/environment as described above.
   - Double-check that `bucket_name` is globally unique and that your ACM certificate and domain are correct.

3. **Initialize Terraform:**
   ```bash
   terraform init
   ```

4. **Review the plan:**
   ```bash
   terraform plan
   ```

5. **Apply the configuration:**
   ```bash
   terraform apply
   ```
   - Confirm the action when prompted.

6. **Deploy your website content:**
   - Place your static site files in your chosen directory (e.g., `./site`).
   - Upload files to S3:
     ```bash
     aws s3 sync ./site/ s3://<your-bucket-name>/
     ```

7. **Update DNS records:**
   - After Terraform completes, note the CloudFront distribution domain name (e.g., `dxxxxxxx.cloudfront.net`).
   - In your DNS provider's dashboard (e.g., GoDaddy), create a CNAME or A record pointing your domain (e.g., `www.example.com`) to the CloudFront domain.

8. **Access your website:**
   - Visit your custom domain in a browser to verify deployment.

## Configuration

Variables can be set in `terraform.tfvars`, via CLI flags, or environment variables.  
Key variables:

- `bucket_name`: S3 bucket name (must be unique)
- `region`: AWS region for S3 bucket
- `domain_name`: Your custom domain (must match ACM certificate)
- `acm_certificate_arn`: ACM certificate ARN (must be in `us-east-1`)

## Deployment

- All infrastructure resources are managed by Terraform.
- To update website content, re-sync files to S3.
- To update infrastructure, modify Terraform code or variables and re-apply.

## Cleanup

To destroy all resources and avoid ongoing charges:

```bash
terraform destroy
```
- You may need to manually empty the S3 bucket before destruction.

## Troubleshooting

- **ACM Certificate Issues:** Ensure your certificate is in `us-east-1` and covers your domain.
- **DNS Propagation:** DNS changes may take time to propagate. Use tools like `dig` or `nslookup` to verify.
- **CloudFront Caching:** Invalidate the CloudFront cache if you do not see updates:
  ```bash
  aws cloudfront create-invalidation --distribution-id <id> --paths "/*"
  ```
- **S3 Bucket Name Errors:** Bucket names must be globally unique.

## License

MIT License. See [LICENSE](LICENSE) for details.
