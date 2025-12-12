# S3 Static Website Module

This Terraform module creates an S3 bucket configured for static website hosting with public access.

## Features

- Creates an S3 bucket for static website hosting
- Configures website hosting with customizable index document
- Sets up public access policies for website access
- Uploads HTML content to the bucket
- Provides comprehensive outputs for bucket and website URLs

## Usage

```hcl
module "static_website" {
  source = "./modules/s3-static-website"

  bucket_name     = "my-website-bucket"
  force_destroy   = true

  tags = {
    Name        = "My Static Website"
    Environment = "Production"
  }

  website_content = file("./index.html")
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| bucket_name | Name of the S3 bucket for static website hosting | string | - | yes |
| index_document | The index document for the website | string | "index.html" | no |
| website_content | The HTML content to upload to the website | string | - | yes |
| force_destroy | Allow bucket to be destroyed even if it contains objects | bool | false | no |
| tags | Tags to apply to the S3 bucket | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The ID (name) of the S3 bucket |
| bucket_arn | The ARN of the S3 bucket |
| bucket_domain_name | The bucket domain name |
| bucket_regional_domain_name | The bucket region-specific domain name |
| website_endpoint | The website endpoint URL |
| website_domain | The domain of the website endpoint |
| website_url | The full HTTP URL of the website |

## Example

See the root `main.tf` for a complete example deploying a snake game.

## Requirements

- Terraform >= 1.0
- AWS Provider >= 6.0

## Notes

- This module creates a publicly accessible S3 bucket
- The bucket policy allows public read access to all objects
- Public access block settings are disabled to allow website hosting
- Use `force_destroy = true` cautiously as it allows bucket deletion with content
