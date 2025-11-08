# Setting DNS Records in GoDaddy for AWS CloudFront

This guide helps you configure your GoDaddy DNS settings to point your domain to your AWS CloudFront distribution.

## Getting Your CloudFront Domain Name

1. **Navigate to your environment directory:**
   ```bash
   cd environments/dev
   ```

2. **Get the CloudFront domain name from Terraform outputs:**
   ```bash
   # Option 1: View all outputs in JSON format
   terraform output -json > tf-outputs.json
   
   # Option 2: Get just the CloudFront domain name
   terraform output -json distribution_domain_name | jq -r .value
   ```

   The command will output something like: `dxxxxxxx.cloudfront.net`

3. **Save this domain name for the next steps**

## Prerequisites

- You have completed Terraform deployment and retrieved your CloudFront distribution domain from the steps above
- You have access to your GoDaddy account and domain

## Steps

1. **Log in to GoDaddy:**
   - Go to [GoDaddy](https://godaddy.com) and sign in.

2. **Navigate to Domain Management:**
   - Click on "My Products".
   - Find your domain and click "DNS" or "Manage DNS".

3. **Add or Edit DNS Record:**
   - To use a subdomain (e.g., `www.example.com`):
     - Click "Add" to create a new record.
     - Select **Type:** `CNAME`
     - **Name:** `www`
     - **Value:** Your CloudFront domain (e.g., `dxxxxxxx.cloudfront.net`)
     - **TTL:** Leave default or set to 1 hour.
   - To use the root domain (e.g., `example.com`):
     - GoDaddy does not support CNAME records for the root domain.
     - Use an **A record** with ALIAS/ANAME (if supported) or use GoDaddy's forwarding feature to redirect `example.com` to `www.example.com`.

4. **Save Changes:**
   - Click "Save" to apply the new DNS record.

5. **Wait for DNS Propagation:**
   - DNS changes may take up to 24 hours to propagate globally.
   - Use tools like [DNS Checker](https://dnschecker.org/) to verify.

## Example

Using the CloudFront domain from your `tf-outputs.json`:

| Type   | Name | Value                        | TTL    |
|--------|------|-----------------------------|--------|
| CNAME  | www  | dxxxxxxx.cloudfront.net     | 1 hour |

You can quickly get your domain name for copying with:
```bash
terraform output -json distribution_domain_name | jq -r .value
```

## Notes

- Ensure your CloudFront distribution is configured to accept requests for your domain.
- For HTTPS, your ACM certificate must cover the domain/subdomain you are pointing to CloudFront.

## Troubleshooting

- If your site does not load, check:
  - DNS propagation status.
  - CloudFront distribution settings (alternate domain names).
  - ACM certificate validity.
  - S3 bucket permissions.

