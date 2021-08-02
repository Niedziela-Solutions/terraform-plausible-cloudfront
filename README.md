# Terraform Plausible Setup

Terraform script to proxy [Plausible](https://plausible.io) through [Cloudfront](https://plausible.io/docs/proxy/guides/cloudfront)

[Niedziela Solutions, LLC's website uses Plausible for analytics.](https://www.niedzielasolutions.com)

## Requirements

- [Terraform](https://learn.hashicorp.com/terraform/getting-started/install)
- AWS Account / Plausible Account
- S3 Bucket with server-side encryption enabled. This is to [store the Terraform state remotely](https://www.terraform.io/docs/language/state/remote.html) in [an S3 Bucket](https://www.terraform.io/docs/language/settings/backends/s3.html).

## Usage

1. `terraform init -backend-config="profile=YOUR_AWS_PROFILE"`. It will prompt you for the required information.
1. `cp environment.tfvars.example environment.tfvars` and change as needed. You'll need to find the IDs for the two managed Cloudfront policies in the AWS Admin under Cloudfront -> Policies. Find `CachingDisabled` (Cache) and `UserAgentRefererHeaders` (Origin Request) then pull the ID from the URL. You can also remove the configuration for the policies in Terraform and manually set it up then find the drift for it and set the IDs that way.
1. Verify: `terraform plan -var-file=environment.tfvars`
1. Invoke: `terraform apply -var-file=environment.tfvars`

After the Cloudfront distribution is setup, you can change DNS to point to this Cloudfront distribution for your analytics subdomain.
