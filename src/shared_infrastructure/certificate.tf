resource "aws_acm_certificate" "certificate" {
  domain_name       = "morphlow.com"
  validation_method = "DNS"

  tags = {
    Project = "morphlow"
  }

  lifecycle {
    create_before_destroy = true
  }
}