# Static Website with S3 Infrastructure

Terraform configuration for securely hosting a static website on AWS S3, featuring blocked public access, CloudFront integration for CDN, and automated deployment of site content. This solution is ideal for scalable, secure, and cost-effective static site hosting.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Customization](#customization)
- [Usage](#usage)
- [Website Content Updates](#website-content-updates)
- [Configuration](#configuration)
- [Terraform Outputs](#terraform-outputs)
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

## Project Structure

```
.
├── bootstrap/
│   └── backend/               # Remote backend module and state
│       └── backend-outputs.json # Backend outputs (s3_bucket_name, s3_bucket_region)
├── environments/
│   └── dev/                    # Development environment configuration
│       ├── main.tf            # Main Terraform configuration
│       ├── variables.tf       # Variable definitions
│       ├── terraform.tfvars   # Variable values
│       ├── tf-outputs.json    # Environment Terraform outputs in JSON format
│       └── versions.tf        # Provider and version constraints
├── modules/
│   ├── bucket_policy/         # S3 bucket policy module
│   ├── cloudfront_distribution/# CloudFront distribution module
│   └── s3_bucket/            # S3 bucket configuration module
├── website-content/           # Static website files
│   ├── index.html
│   ├── 404.html
│   └── styles.css
├── godaddy_dns_instructions.md # Guide: updating GoDaddy DNS for CloudFront
└── README.md
```

## Customization

Before deploying, you **must** update the following values to match your environment and requirements:

| Variable                | Description                                                                 | Where to Set                |
|-------------------------|-----------------------------------------------------------------------------|-----------------------------|
| `project_name`          | Project identifier used to generate resource names                          | `environments/dev/terraform.tfvars` or CLI |
| `environment_name`      | Environment for deployment (dev, prod, etc.)                                | `environments/dev/terraform.tfvars` or CLI |
| `owner`                 | Owner name or team identifier                                                | `environments/dev/terraform.tfvars` or CLI |
| `noncurrent_days`       | Days after which noncurrent object versions are removed                     | `environments/dev/terraform.tfvars` or CLI |
| `website_content_path`  | Path to local website files to upload                                       | `environments/dev/terraform.tfvars` or CLI |
| `region`                | AWS region for resources                                                     | `environments/dev/terraform.tfvars` or CLI |
| `acm_certificate_arn`   | ARN of the ACM certificate for CloudFront (must be in `us-east-1`)          | `environments/dev/terraform.tfvars` or CLI |
| `my_domain_names`       | List of domain names (CNAMEs) to associate with CloudFront                  | `environments/dev/terraform.tfvars` or CLI |

Notes:
- The S3 bucket name is automatically generated by the root module using the pattern:
```
${var.project_name}-${var.environment_name}-${var.owner}-bucket
```
- You can override this behavior by directly setting `bucket_name` in `terraform.tfvars` if you prefer a specific name (ensure global uniqueness).

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
   - Initial deployment is handled automatically by Terraform using the files in the `website-content` directory
   - For subsequent updates, see the [Website Content Updates](#website-content-updates) section

7. **Update DNS records:**
   - After Terraform completes, note the CloudFront distribution domain name (e.g., `dxxxxxxx.cloudfront.net`).
   - In your DNS provider's dashboard (e.g., GoDaddy), create a CNAME or A record pointing your domain (e.g., `www.example.com`) to the CloudFront domain.

8. **Access your website:**
   - Visit your custom domain in a browser to verify deployment.

## Website Content Updates

While the initial website content is deployed automatically by Terraform, subsequent updates can be easily managed using AWS CLI commands. This approach is simple and efficient - no need for complex tools like Ansible which would be overkill for this purpose.

### Updating Website Files

1. **Sync updated files to S3:**
   ```bash
   # Replace YOUR_BUCKET_NAME with your actual bucket name from bootstrap/backend/backend-outputs.json
   aws s3 sync ./website-content/ s3://YOUR_BUCKET_NAME/ --delete
   ```
   - The `--delete` flag removes files in the bucket that don't exist locally
   - Remove `--delete` if you want to keep existing files in the bucket

2. **Invalidate CloudFront cache:**
   ```bash
   # Replace DISTRIBUTION_ID with your CloudFront distribution ID (from environments/<env>/tf-outputs.json)
   aws cloudfront create-invalidation --distribution-id DISTRIBUTION_ID --paths "/*"
   ```

### Best Practices for Updates

- Always test your changes locally before uploading
- Use `aws s3 sync --dryrun` to preview changes before applying
- Consider creating a simple shell script for frequent updates:
  ```bash
  #!/bin/bash
  BUCKET_NAME="your-bucket-name"
  DISTRIBUTION_ID="your-distribution-id"
  
  aws s3 sync ./website-content/ s3://$BUCKET_NAME/ --delete
  aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*"
  ```

Note: While tools like Ansible could be used for this purpose, they would add unnecessary complexity for such a straightforward task. The AWS CLI provides all the functionality needed for efficient website updates and cache management.

## Configuration

Variables can be set in `terraform.tfvars`, via CLI flags, or environment variables.  
Key variables:

- `project_name`: Name of your project (used in resource naming)
- `environment_name`: Environment name (e.g., dev, prod)
- `owner`: Owner name or identifier
- `region`: AWS region for S3 bucket
- `domain_name`: Your custom domain (must match ACM certificate)
- `acm_certificate_arn`: ACM certificate ARN (must be in `us-east-1`)

The S3 bucket name is automatically generated using the pattern:
```
${var.project_name}-${var.environment_name}-${var.owner}-bucket
```

## Remote backend

This repository includes a prebuilt remote backend configuration in `bootstrap/backend/` that provisions a shared S3 bucket for Terraform remote state. For setup and usage instructions, see `backend_instructions.md` in the repository root.


## Terraform Outputs

After applying the Terraform configuration, outputs are not saved to a file automatically. There are two kinds of outputs you may want to export:

- Backend outputs (S3 bucket and region) — create the backend first from `bootstrap/backend`, then export outputs there:

```bash
cd bootstrap/backend
# Export backend outputs to the canonical file used by this repo
terraform output -json > backend-outputs.json
```

- Environment outputs (CloudFront distribution, etc.) — export from the environment directory after applying the environment:

```bash
cd environments/dev
terraform output -json > tf-outputs.json

# (Optional) Get just the CloudFront domain name (useful for scripts)
terraform output -json distribution_domain_name | jq -r .value > cloudfront-domain.txt
```

If you prefer a single chained command for environment apply + export, you can run apply and then export outputs in one line (careful with automation and approvals):

```bash
# Run apply non-interactively and export environment outputs to tf-outputs.json
terraform apply -auto-approve && terraform output -json > tf-outputs.json
```

Backend and environment output files will contain structured output entries. Example excerpt (environment outputs):
```json
{
   "distribution_domain_name": {
      "value": "dxxxxxxx.cloudfront.net",
      "type": "string"
   },
   "s3_bucket_name": {
      "value": "your-bucket-name",
      "type": "string"
   }
}
```

Use the CloudFront domain name from the environment outputs file to configure your DNS records at your domain registrar (e.g., GoDaddy). See [godaddy_dns_instructions.md](godaddy_dns_instructions.md) for detailed DNS setup steps.

## Deployment

- All infrastructure resources are managed by Terraform.
- Initial website content is deployed automatically from the `website-content` directory.
- For subsequent content updates, use the AWS CLI commands as described in [Website Content Updates](#website-content-updates).
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
