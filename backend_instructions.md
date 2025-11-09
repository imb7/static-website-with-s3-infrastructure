# Terraform Backend Infrastructure

This repository provisions a shared remote backend for Terraform projects on AWS. It creates a secure S3 bucket to hold Terraform state with server-side encryption, versioning, lifecycle rules and settings that enable S3 native locking.

## Table of contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Output Management](#output-management)
- [Backend configuration example (S3 native locking)](#backend-configuration-example-s3-native-locking)
- [Notes and best practices](#notes-and-best-practices)

## Overview

This project creates foundational backend resources used by downstream Terraform configurations: an S3 bucket for remote state with server-side encryption, versioning, lifecycle rules and settings that enable S3 native locking.

The recommended approach is to use S3 native locking (no extra AWS resources required).

## Architecture

- S3 state bucket: Private, versioned, and encrypted (SSE-S3 by default). The repository uses a variable-based bucket naming pattern to keep names unique per environment and owner.
- Locking: S3 native locking — enabled via `use_lockfile = true` in the S3 backend block. No additional AWS resources are required.

## Prerequisites

- Terraform CLI: Use a recent Terraform version that supports S3 native locking (Terraform 1.3+ is recommended).
- AWS credentials/role with permissions to create and manage the S3 bucket and associated resources.

### IAM permissions (examples)

- S3-related: `s3:CreateBucket`, `s3:PutBucketVersioning`, `s3:PutEncryptionConfiguration`, `s3:PutBucketPolicy` (if used), `s3:GetObject`, `s3:PutObject`, `s3:DeleteObject`.

## Usage

1. Configure variables

Create or update `terraform.tfvars` with the required variables. See `variables.tf` for exact names and defaults.

Common variables (see `variables.tf`):

- `project_name` — name of the project used when constructing the S3 bucket name
- `environment_name` — environment identifier (e.g., `dev`, `prod`)
- `owner` — owner identifier used in bucket naming
- `region` — AWS region where the bucket will be created (default: `us-east-1`)
- `noncurrent_days` — days to retain noncurrent object versions before deletion

2. Deploy backend resources

```bash
# Initialize:
terraform init

# Review:
terraform plan -var-file=terraform.tfvars

# Apply:
terraform apply -var-file=terraform.tfvars
```

Create the backend first (recommended)

It's best to provision the remote backend before applying any downstream environment configuration. From the repository root:

```bash
cd bootstrap/backend
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

After a successful apply, export the backend outputs to a JSON file that other parts of this repo can consume:

```bash
terraform output -json > backend-outputs.json
```

The `backend-outputs.json` file will contain values such as `s3_bucket_name` and `s3_bucket_region` which downstream environment configs can reuse when configuring their local `backend` blocks.

## Output Management

To save and reuse Terraform outputs, export them to a JSON file. For backend outputs (S3 bucket and region) we recommend exporting from `bootstrap/backend` into `backend-outputs.json`:

```bash
# from bootstrap/backend after apply
terraform output -json > backend-outputs.json
```

Downstream environment outputs (for example CloudFront distribution IDs) can still be exported from the environment directory (e.g. `environments/dev`) using the traditional `tf-outputs.json` name if you prefer:

```bash
cd ../../environments/dev
terraform output -json > tf-outputs.json
```

Use the backend outputs (`bootstrap/backend/backend-outputs.json`) for values required to configure remote state (for example `s3_bucket_name` and `s3_bucket_region`). Use environment outputs (`environments/<env>/tf-outputs.json`) for resources created by that environment (for example `distribution_domain_name` or `distribution_id`).

## Backend configuration example (S3 native locking)

Preferred (S3 native locking):

```hcl
terraform {
  backend "s3" {
    bucket       = "<s3-bucket-name>"                # e.g. "acme-prod-tf-state"
    key          = "platform/shared/backend.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

## Notes and best practices

- Prefer S3 native locking for new projects unless you have a specific need for an alternate lock store.
- Coordinate with your team and CI systems when changing backend settings to avoid mid-operation conflicts.

Refer to the repository files (especially `variables.tf`) for the authoritative list of variables, defaults, and descriptions.