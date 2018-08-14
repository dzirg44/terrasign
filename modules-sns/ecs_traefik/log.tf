// Delete in future, but good for now, because ELK(EFK) stack doesn't implemented.
resource "aws_cloudwatch_log_group" "default" {
  count             = "${length(var.branches_ingress_traefik_var)}"
  name              = "${var.cluster_name_ecs_out}-${element(var.branches_ingress_traefik_var, count.index)}/ingress_traefik"
  retention_in_days = "${var._task_log_retention_in_days_ingress_traefik_var}"
}
