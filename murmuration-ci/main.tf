resource "aws_s3_bucket" "parlai" {
  bucket = "may3parl.ai"

  tags = {
    Name        = "My bucket"
    Environment = "parlai Dev"
  }
}

resource "aws_s3_bucket_website_configuration" "parlai" {
  bucket = aws_s3_bucket.parlai.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "parlai" {
  bucket = aws_s3_bucket.parlai.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "parlai" {
  bucket = aws_s3_bucket.parlai.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "parlai" {
  depends_on = [
    aws_s3_bucket_ownership_controls.parlai,
    aws_s3_bucket_public_access_block.parlai,
  ]

  bucket = aws_s3_bucket.parlai.id
  acl    = "public-read"
}


resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.parlai.id
  key = "index.html"
  source = "${path.module}/index.html"
}
#

# Route53 

resource "aws_route53_zone" "parlai" {
  name = "test.parlai.com"
}

resource "aws_route53_record" "parlai_record" {
  zone_id = aws_route53_zone.parlai.zone_id
  name    = "test.parlai.com"
  type    = "CNAME"

  alias {
    name                   = "may3parl.ai.s3-website-us-east-1.amazonaws.com"
    zone_id                = aws_s3_bucket.parlai.hosted_zone_id
    evaluate_target_health = true
  }
}


# resource "aws_route53_record" "parlai" {
#   allow_overwrite = true
#   name            = "test.parlai.com"
#   ttl             = 172800
#   type            = "NS"
#   zone_id         = aws_route53_zone.parlai.zone_id

#   records = [
#     aws_route53_zone.parlai.name_servers[0],
#     aws_route53_zone.parlai.name_servers[1],
#     aws_route53_zone.parlai.name_servers[2],
#     aws_route53_zone.parlai.name_servers[3],
#   ]
# }
