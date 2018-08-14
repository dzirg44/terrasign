#######################################################
# GENERAL VARIABLES
#######################################################
//https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-placement-strategies.html
variable "placement_strategy_type_ingress_traefik_var" {
  default     = "spread"
  description = "Placement strategy - binpack, random, or spread"
}
// https://docs.aws.amazon.com/AmazonECS/latest/APIReference/API_PlacementStrategy.html
variable "placement_strategy_field_ingress_traefik_var" {
  default = "attribute:ecs.availability-zone"
}
//https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-placement-constraints.html#constraint-types
variable "placement_constraint_type_ingress_traefik_var" {
  default     = "distinctInstance"
  description = "The type of constraint -  memberOf and distinctInstance."
}
//https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/dns-failover-complex-configs.html
variable "_evaluate_target_health_ingress_traefik_var" {
  default = true
}
# ! private
variable "_task_log_retention_in_days_ingress_traefik_var" {
  default = 7
}

#######################################################
# VPC VARIABLES
#######################################################
variable "vpc_id_vpc_out" {
  description = "The main VPC network"
}
variable "public_subnet_ids_vpc_out" {
  type        = "list"
  description = "Public subnets ids with loadbalancers"
}

variable "vpc_cidr_vpn_subnet_vpc_out" {
  type        = "list"
  description = "VPN Cidr list for the VPC"
}
variable "kms_master_key_arn_vpc_out" {
  description = "KMS master key"
}

#######################################################
# ECS CLUSTER VARIABLES
#######################################################
variable "cluster_name_ecs_out" {
  description = "ECS Cluster name for Traefik configuration"
}

variable "cluster_arns_ecs_out" {
  type        = "list"
  description = "ECS Cluster arns for Traefik configuration"
}

variable "cluster_ids_ecs_out" {
  type        = "list"
  description = "ECS Cluster ids"
}
variable "instance_security_group_id_ecs_out" {
  description = "The security group for the container instances in theECS "
}

##########################################################
# TRAEFIK MAIN VARIABLES
##########################################################
variable "_image_ingress_traefik_var" {
  description = "traefik base image"
  default = "traefik:1.6"
}
variable "size_ingress_traefik_var" {
  default     = 1
  description = "The number of instances in the task definition"
}
// https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html#sticky-sessions
variable "enable_stickiness_ingress_traefik_var" {
  default     = true
  description = "Sticky sessions for the Traefik - ALB"
}

variable "enable_web_ingress_traefik_var" {
  default     = true
  description = "webUI interfaces for Traefik (statistics, dashboard etc.)"
}
variable "port_web_ingress_traefik_var" {
  default     = 8080
  description = "Traefik admin web address port"
}

variable "port_http_ingress_traefik_var" {
  default     = 80
  description = "Traefik http port"
}

variable "port_https_ingress_traefik_var" {
  default     = 443
  description = "Traefik https port"
}
variable "branches_ingress_traefik_var" {
  description = "branches for the Traefik"
  type        = "list"

  default = [
    "master",
    "develop",
  ]
}

##########################################################
# TRAEFIK VARIABLES - CONTAINER LIMITATIONS
##########################################################

variable "cpu_ingress_traefik_var" {
  default     = 128
  description = "The CPU limit container"
}

variable "memory_trafik_var" {
  default     = 128
  description = "The memory limit container"
}

variable "memory_reservation_ingress_traefik_var" {
  default     = 64
  description = "Soft limit (in MiB) of memory"
}

###############################################################
# TRAEFIK ROUTE 53 VARIABLES
###############################################################
variable "route53_zone_ingress_traefik_var" {
  description = "Route 53 zone for the wildcard Traefik"
}
variable "route53_wildcard_zone_ingress_traefik_var" {
  description = "Route 53 wildcard domain"
}

variable "domain_list_ingress_traefik_var" {
  description = "Domains to automatic get certificates for Traefik"
  type        = "list"
  default     = []
}