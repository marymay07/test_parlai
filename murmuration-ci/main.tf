resource "aws_s3_bucket" "parlai" {
  bucket = "may3parl.ai"

  tags = {
    Name        = "My bucket"
    Environment = "parlai Dev"
  }
}
