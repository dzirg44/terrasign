####################################################################
# ALB VARIABLES
###################################################################
variable "name_alb_var" {
  default     = "default"
  description = "Name Loadbalancer"
}

variable "branches_alb_var" {
  description = "Description for alb"
  type = "list"
}

variable "certificate_arns" {
  type        = "list"
  description = "Current certificate ARN for the Albs"
}

variable "deregistration_delay_alb_var" {
  default     = "300"
  description = "Deregistration delay"
}

variable "health_check_path_alb_var" {
  default     = "/"
  description = "Health check path"
}

variable "allow_cidr_block_alb_var" {
  default     = "0.0.0.0/0"
  description = "Cird block to acces the LoadBalancer"
}

variable "enable_stickiness_alb_var" {
  default     = false
  description = "Stickiness for the ALB"
}

variable "stickiness_cookie_duration_alb_var" {
  default     = 300
  description = "Stickiness cookie duration"
}
variable "tags_alb_var" {
  description = "Tags for LB"
  type    = "map"
  default = {}
}
#################################################################
# ECS VARIABLES
#################################################################
variable "cluster_ecs_out" {
  default     = "default"
  description = "Cluster load balance"
}
variable "instance_security_group_id_ecs_out" {}


#################################################################
# NETWORK VARIABLES
#################################################################
variable "vpc_id_vpc_out" {
  description = "Current VPC id"
}

variable "public_subnet_ids_vpc_out" {
  type        = "list"
  description = "Public subnet ids for the loadbalancer in"
}
##################################################################
# TRAEFIK ENABLE in ALB
##################################################################
variable "enable_traefik_alb_var" {
  default     = false
  description = "Traefik ecurity roles and target groups"
}

////////////// PV /////////////////
variable "_enable_http2_alb_var" {
  description = "Http2 protocol for load balancers"
  default = true
}