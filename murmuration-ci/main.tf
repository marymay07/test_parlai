resource "aws_s3_bucket" "parlai" {
  bucket = "may3parl.ai"


  tags = {
    Name        = "My bucket"
    Environment = "parlai Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "example" {
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
