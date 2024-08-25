resource "aws_lb_target_group" "target_group" {
  for_each = local.environments

  name        = "${each.key}-lb-tg"
  port        = 443
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc[each.key].id
}
