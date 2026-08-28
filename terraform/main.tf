provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "resume_bucket" {
  bucket = "reejan-pariyar-cloud-resume-2026"
}

resource "aws_s3_bucket_website_configuration" "resume_website" {
  bucket = aws_s3_bucket.resume_bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "resume_policy" {
  bucket = aws_s3_bucket.resume_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.resume_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_cloudfront_distribution" "resume_cdn" {
  enabled             = true
  default_root_object = "index.html"
  is_ipv6_enabled      = true

  tags = {
    Name = "reejan-cloud-resume"
  }

  origin {
    domain_name = aws_s3_bucket_website_configuration.resume_website.website_endpoint
    origin_id   = "reejan-pariyar-cloud-resume-2026.s3-website.eu-north-1.amazonaws.com-msr8zi3xtto"

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port               = 80
      https_port               = 443
      origin_ssl_protocols     = ["SSLv3", "TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods         = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    target_origin_id         = "reejan-pariyar-cloud-resume-2026.s3-website.eu-north-1.amazonaws.com-msr8zi3xtto"
    viewer_protocol_policy   = "redirect-to-https"
    compress                 = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
