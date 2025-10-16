# Static Website with S3 Infrastructure

Terraform configuration for securely hosting a static website on AWS S3, featuring blocked public access, CloudFront integration for CDN, and automated deployment of site content. Ideal for scalable, secure, and cost-effective static site hosting solutions.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Cleanup](#cleanup)
- [License](#license)

## Overview

This project provides Terraform code to provision a secure, production-ready static website hosting environment on AWS. It leverages S3 for storage, CloudFront for CDN and HTTPS, and IAM for secure access.

## Architecture

- **Amazon S3**: Stores static website files (HTML, CSS, JS, images).
- **CloudFront**: Distributes content globally, provides HTTPS, and restricts direct S3 access.
- **IAM**: Manages permissions for deployment automation.
- **(Optional) Route 53**: For custom domain DNS management.

```
[User] ---> [CloudFront CDN] ---> [S3 Bucket (private)]
```

## Features

- **Private S3 bucket**: Blocks all public access.
- **CloudFront distribution**: Serves content securely over HTTPS.
- **Automatic content deployment**: Uploads website files to S3.
- **Configurable domain and SSL**: (Optional) Use your own domain and ACM certificate.
- **Terraform-managed**: Infrastructure as code for easy reproducibility.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.0+
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- An AWS account with permissions to manage S3, CloudFront, and IAM
- (Optional) Registered domain and ACM certificate for HTTPS

## Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/static-website-with-s3-infrastructure.git
   cd static-website-with-s3-infrastructure
   ```

2. **Configure variables:**
   - Edit `terraform.tfvars` or set variables via CLI/environment.
   - Required variables typically include:
     - `bucket_name`
     - `region`
     - (Optional) `domain_name`, `acm_certificate_arn`

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

6. **Deploy your website content:**
   - Place your static site files in the designated directory (see module or variable for path).
   - Use the provided script or AWS CLI to sync files:
     ```bash
     aws s3 sync ./site/ s3://<your-bucket-name>/
     ```

7. **Access your website:**
   - Use the CloudFront distribution domain or your custom domain.

## Configuration

Customize variables in `variables.tf` or via `terraform.tfvars`:

- `bucket_name`: Name of your S3 bucket
- `region`: AWS region
- `domain_name`: (Optional) Custom domain
- `acm_certificate_arn`: (Optional) ACM certificate ARN for HTTPS

## Deployment

- All resources are managed by Terraform.
- To update website content, re-sync files to S3.
- To update infrastructure, modify Terraform code and re-apply.

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## License

MIT License. See [LICENSE](LICENSE) for details.
