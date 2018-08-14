resource "aws_alb_target_group" "default" {
  count                = "${length(var.branches_alb_var)}"
  name                 = "${var.name_alb_var}-${element(var.branches_alb_var, count.index)}"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id_vpc_out}"
  deregistration_delay = "${var.deregistration_delay_alb_var}"

  health_check {
    path     = "${var.health_check_path_alb_var}"
    protocol = "HTTP"
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = "${var.stickiness_cookie_duration_alb_var}"
    enabled         = "${var.enable_stickiness_alb_var}"
  }
}

resource "aws_alb" "alb" {
  count           = "${length(var.branches_alb_var)}"
  name            = "${var.name_alb_var}-${element(var.branches_alb_var, count.index)}"
  subnets         = ["${var.public_subnet_ids_vpc_out}"]
  security_groups = ["${aws_security_group.alb.id}"]
  enable_http2    = "${var._enable_http2_alb_var}"
}

resource "aws_alb_listener" "http" {
  count             = "${length(var.branches_alb_var)}"
  load_balancer_arn = "${element(aws_alb.alb.*.id, count.index)}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${element(aws_alb_target_group.default.*.arn, count.index)}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "https" {
  count             = "${length(var.branches_alb_var)}"
  load_balancer_arn = "${element(aws_alb.alb.*.id, count.index)}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2015-05"
  certificate_arn   = "${element(var.certificate_arns, count.index)}"

  default_action {
    target_group_arn = "${element(aws_alb_target_group.default.*.arn, count.index)}"
    type             = "forward"
  }
}

resource "aws_security_group" "alb" {
  name   = "${var.name_alb_var}-alb"
  vpc_id = "${var.vpc_id_vpc_out}"

  tags = "${ merge( var.tags_alb_var, map( "Name", var.name_alb_var ), map( "Terraform", "true" ) ) }"
}

resource "aws_security_group_rule" "http_from_anywhere" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["${var.allow_cidr_block_alb_var}"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "https_from_anywhere" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["${var.allow_cidr_block_alb_var}"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "alb_to_traefik" {
  count                    = "${var.enable_traefik_alb_var}"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "TCP"
  source_security_group_id = "${aws_security_group.alb.id}"
  security_group_id        = "${var.instance_security_group_id_ecs_out}"
}
// Kubernetes ---- ELB
resource "aws_security_group_rule" "alb_to_ecs" {
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 61000
  protocol                 = "TCP"
  source_security_group_id = "${aws_security_group.alb.id}"
  security_group_id        = "${var.instance_security_group_id_ecs_out}"
}
