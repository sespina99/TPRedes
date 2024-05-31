locals {
  s3_bucket_name = "wesite-test-bucket-redes-grupo25"
  base_domain    = "redes-grupo25.com.ar"
  hosted_zone_id = ""
  cert_arn       = ""
}

resource "aws_route53_zone" "primary" {
  name = local.base_domain
}

#ACM
module "acm" {
  source = "./modules/acm"

  base_domain = local.base_domain
  zone_id     = aws_route53_zone.primary.zone_id
}

#HOSTED ZONE AND ACM CREATED, NOW CLOUDFRONT AND S3 BUCKET

#S3
resource "aws_s3_bucket" "this" {
  bucket = local.s3_bucket_name
}

#CLOUDFRONT
resource "aws_cloudfront_distribution" "main" {
  enabled = true
  aliases = [local.base_domain]
  default_root_object = "index.html"
  is_ipv6_enabled = true
  wait_for_deployment = true

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.this.bucket
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    viewer_protocol_policy = "redirect-to-https"
  }

  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.this.bucket
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = module.acm.certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_control" "main" {
  name                              = "s3-cloudfront-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


data "aws_iam_policy_document" "cloudfront_oac_access" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = ["${aws_s3_bucket.this.arn}/*"]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.main.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.cloudfront_oac_access.json
}

resource "aws_route53_record" "this" {
  zone_id = aws_route53_zone.primary.zone_id
  name = local.base_domain
  type = "A"
  alias {
    name = aws_cloudfront_distribution.main.domain_name
    zone_id = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.${local.base_domain}"
  type    = "CNAME"
  ttl     = 600
  records = ["${local.base_domain}"]
  depends_on = [
    aws_route53_record.this
  ]
}


resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.this.bucket
  key = "index.html"
  source = "index.html"
}