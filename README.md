# Cloud Resume Challenge

A personal resume site deployed as a real, live AWS cloud project, not just hosted, but built to understand the full infrastructure behind it.

**Live site:** https://d39rgsyhh5t880.cloudfront.net

## What I did

I hosted a static HTML resume on Amazon S3, configuring it for public static website hosting. This required removing S3's default "Block Public Access" protections and applying a custom bucket policy to grant public read access, a deliberate security trade-off, since S3 buckets are private by default.

I then added Amazon CloudFront in front of the S3 origin to serve the site over HTTPS (S3 static hosting alone only supports HTTP). During setup, I hit a real 504 Gateway Timeout error. I diagnosed the cause by inspecting the CloudFront origin settings and discovered that S3 website endpoints only support HTTP on the backend connection, not HTTPS. Fixing the origin protocol setting resolved it.

## Tech stack

- Amazon S3 (static website hosting)
- Amazon CloudFront (HTTPS, global CDN)
- AWS CLI
- Git & GitHub

## Coming next

- Custom domain via Route 53
- Visitor counter with Lambda + DynamoDB
- Rebuild infrastructure as Terraform code
- Automated deployment with GitHub Actions
