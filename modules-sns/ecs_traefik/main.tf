##################################################################
# DATA SECTION
##################################################################
data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_ecs_task_definition" "ingress_traefik" {
  count           = "${length(var.branches_ingress_traefik_var)}"
  task_definition = "${element(aws_ecs_task_definition.ingress_traefik.*.family, count.index)}"
  depends_on      = ["aws_ecs_task_definition.ingress_traefik"]
}
data "template_file" "ingress_traefik" {
  count    = "${length(var.branches_ingress_traefik_var)}"
  template = "${file("${path.module}/ingress_traefik.json.tpl")}"

  vars {
    container_name           = "ingress_traefik"
    container_cpu            = "${var.cpu_ingress_traefik_var}"
    container_mem_res        = "${var.memory_reservation_ingress_traefik_var}"
    container_mem            = "${var.memory_reservation_ingress_traefik_var}"
    container_port_web       = "${var.port_web_ingress_traefik_var}"
    container_port_http      = "${var.port_http_ingress_traefik_var}"
    container_port_https     = "${var.port_https_ingress_traefik_var}"
    container_cluster_name   = "${var.cluster_name_ecs_out}-${element(var.branches_ingress_traefik_var, count.index)}"
    container_cluster_region = "${data.aws_region.current.name}"

    container_log_group  = "${var.cluster_name_ecs_out}-${element(var.branches_ingress_traefik_var, count.index)}/ingress_traefik"
    container_log_region = "${data.aws_region.current.name}"

    container_image = "${var._image_ingress_traefik_var}"
  }
}
##################################################################
# ECS MODULE DEFINE SECTION
##################################################################
module "ecs_alb" {
  source = "../ecs_alb"

  branches_alb_var          = "${var.branches_ingress_traefik_var}"
  name_alb_var              = "${var.cluster_name_ecs_out}-t"
  health_check_path_alb_var = "/ping"

  vpc_id_vpc_out                         = "${var.vpc_id_vpc_out}"
  public_subnet_ids_vpc_out          = ["${var.public_subnet_ids_vpc_out}"]
  instance_security_group_id_ecs_out     = "${var.instance_security_group_id_ecs_out}"
  certificate_arns           = ["${data.aws_acm_certificate.default.*.arn}", "${data.aws_acm_certificate.cert.*.arn}" ]
  enable_traefik_alb_var             = true
}
#####################################################################
# ECS CONFIGURATION SECTION
#####################################################################
resource "aws_ecs_service" "ingress_traefik" {
  count           = "${length(var.cluster_ids_ecs_out)}"
  name            = "ingress_traefik"
  cluster         = "${element(var.cluster_ids_ecs_out, count.index)}"
  desired_count   = "${var.size_ingress_traefik_var}"
  // https://github.com/hashicorp/terraform/issues/3182
  task_definition = "${element(aws_ecs_task_definition.ingress_traefik.*.family, count.index)}:${max("${element(aws_ecs_task_definition.ingress_traefik.*.revision, count.index)}", "${element(data.aws_ecs_task_definition.ingress_traefik.*.revision, count.index)}")}"


  placement_strategy {
    type  = "${var.placement_strategy_type_ingress_traefik_var}"
    field = "${var.placement_strategy_field_ingress_traefik_var}"
  }
  load_balancer {
    target_group_arn = "${element(module.ecs_alb.default_alb_target_groups_alb_out, count.index)}"
    container_name   = "ingress_traefik"
    container_port   = "${var.port_http_ingress_traefik_var}"
  }
  placement_constraints {
    type = "${var.placement_constraint_type_ingress_traefik_var}"
  }
  depends_on = ["module.ecs_alb"]
}

resource "aws_ecs_task_definition" "ingress_traefik" {
  count = "${length(var.branches_ingress_traefik_var)}"

  family = "${var.cluster_name_ecs_out}-${element(var.branches_ingress_traefik_var, count.index)}-ingress_traefik"

  container_definitions = "${element(data.template_file.ingress_traefik.*.rendered, count.index)}"
  network_mode          = "bridge"

  task_role_arn = "${aws_iam_role.task.arn}"
}




