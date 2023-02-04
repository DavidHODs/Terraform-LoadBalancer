data "aws_route53_zone" "terra-zone" {
  zone_id = lookup(var.access_key, "zone_id")
  private_zone = false
}

resource "aws_route53_record" "terra-53" {
  zone_id = data.aws_route53_zone.terra-zone.zone_id
  name    = "terraform-test.${data.aws_route53_zone.terra-zone.name}"
  type    = "A"
  allow_overwrite = true

  alias {
    name                   = aws_lb.terra_lb.dns_name
    zone_id                = aws_lb.terra_lb.zone_id
    evaluate_target_health = false
  }
}
