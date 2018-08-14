// Using for FOR ACME only
data "aws_route53_zone" "default" {
  name = "${var.route53_zone_ingress_traefik_var}"
  private_zone=true
}

resource "aws_route53_record" "default" {
  count   = "${length(var.branches_ingress_traefik_var)}"
  zone_id = "${data.aws_route53_zone.default.zone_id}"
  name    = "*.${element(var.branches_ingress_traefik_var, count.index)}.${var.route53_wildcard_zone_ingress_traefik_var}"
  type    = "A"

  alias {
    name                   = "${element(module.ecs_alb.default_alb_dns_names_alb_out, count.index)}"
    zone_id                = "${element(module.ecs_alb.default_alb_zone_ids_alb_out, count.index)}"
    evaluate_target_health = "${var._evaluate_target_health_ingress_traefik_var}"
  }
}
