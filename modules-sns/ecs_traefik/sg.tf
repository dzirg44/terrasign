resource "aws_security_group_rule" "web" {
  count             = "${var.enable_web_ingress_traefik_var}"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "TCP"
  cidr_blocks       = ["${concat(var.vpc_cidr_vpn_subnet_vpc_out)}"]
  security_group_id = "${var.instance_security_group_id_ecs_out}"
}
// Kubernetes
resource "aws_security_group_rule" "ingress_traefik" {
  count                    = "${var.enable_web_ingress_traefik_var}"
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 61000
  protocol                 = "TCP"
  source_security_group_id = "${var.instance_security_group_id_ecs_out}"
  security_group_id        = "${var.instance_security_group_id_ecs_out}"
}
