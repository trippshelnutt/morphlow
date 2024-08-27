data "aws_route53_zone" "morphlow" {
  name = "morphlow.com."
}

resource "aws_route53_record" "qa" {
  for_each = local.environments

  zone_id = data.aws_route53_zone.morphlow.id
  name    = "*.${each.key}.morphlow.com."
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb.app_load_balancer[each.key].dns_name]
}
