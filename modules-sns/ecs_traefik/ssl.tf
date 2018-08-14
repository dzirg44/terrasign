// GET certificate for traefik ALB
data "aws_acm_certificate" "default" {
  count  = "${length(var.branches_ingress_traefik_var)}"
  domain = "*.${var.route53_wildcard_zone_ingress_traefik_var}"
}

data "aws_acm_certificate" "cert" {
  count  = "${length(var.domain_list_ingress_traefik_var)}"
  domain = "${element(var.domain_list_ingress_traefik_var, count.index)}"
}

