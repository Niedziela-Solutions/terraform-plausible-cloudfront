locals {
  origin_id = "plausible-io"
}

resource "aws_cloudfront_distribution" "plausible_distribution" {
  enabled = true
  price_class = "PriceClass_100"
  retain_on_delete = false
  is_ipv6_enabled = true
  comment = "Managed by Terraform"
  aliases = var.aliases

  origin {
    domain_name = "plausible.io"
    origin_id   = local.origin_id

    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id
    viewer_protocol_policy = "https-only"
    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern     = "/api/event"
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.origin_id
    viewer_protocol_policy = "https-only"
    cache_policy_id = var.caching_disabled_policy_id
    origin_request_policy_id = var.user_agent_referer_headers_policy_id
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
