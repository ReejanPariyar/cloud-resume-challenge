# Cloud Resume Challenge

My CV as a website, hosted on AWS: https://d39rgsyhh5t880.cloudfront.net

I built this by hand in the AWS CLI and console first, so I'd understand each piece before rebuilding it in Terraform.

## How it works

The site is one HTML file in an S3 bucket with static website hosting turned on. S3 website hosting only serves over HTTP, so I put CloudFront in front of it to get HTTPS. CloudFront talks to S3 over HTTP, which is fine because that part stays inside AWS. Visitors still connect over HTTPS.

The visitor counter is a small Python Lambda function. When the page loads, the JavaScript calls the function's URL, the function adds 1 to a number stored in a DynamoDB table, and the new number comes back and gets shown on the page. The function's IAM role can only update that one table and nothing else.

```
browser -> CloudFront -> S3 (the page)
browser -> Lambda URL -> Lambda -> DynamoDB (the counter)
```

## Things that went wrong

CloudFront gave me a 504 at first. It was trying to reach the S3 website endpoint over HTTPS, which that endpoint doesn't support. Setting the origin protocol to HTTP only fixed it.

The Lambda URL returned a 403 even after I'd added the public access permission. AWS now needs a second one (lambda:InvokeFunction, for calls through the function URL), so I added that too.

After updating index.html in S3 the old page kept showing, because CloudFront had cached it. I clear the cache with an invalidation after each upload.

## Deploys, tests and what's left

Pushing a change to index.html deploys it automatically with GitHub Actions (it signs in to AWS with OIDC, so there are no stored keys), and the Lambda function has pytest tests that run on every change to it.

The S3 and CloudFront setup is also written as Terraform in this repo. Still to do: add the visitor counter to the Terraform code.

## Files

- index.html is the page and the counter script
- counter/lambda_function.py is the Lambda function
- policy.json is the S3 public read policy
- trust-policy.json is what lets Lambda use its IAM role
