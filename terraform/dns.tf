# fetches the details of an existing hosted zone on aws route53
data "aws_route53_zone" "terra-zone" {
  zone_id = lookup(var.access_key, "zone_id")
  private_zone = false
}

# creates a record on the hosted zone; value points towards the resources of the created application load balancer
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
