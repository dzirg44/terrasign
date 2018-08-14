

module "vpc" {
  source = "./modules-sns/vpc"
  cidr_vpc_var = "10.0.0.0/16"
  vpn_subnet_vpc_var ="${var.vpn_subnet_cidr}"
  public_subnets_vpc_var = "${var.public_subnet_cidrs}"
  private_subnets_vpc_var = "${var.private_subnet_cidrs}"
  azs_vpc_var = "${var.az_aws}"
  name_vpc_var = "${var.environment}"
  enable_nat_gateway_vpc_var = true
  enable_dns_hostnames_vpc_var = true
  enable_dns_support_vpc_var = true
  tags_vpc_var = {
    Network = "vpc-${var.environment}"
  }
  public_subnet_tags_vpc_var = {
    NetworkSubnet = "vpc-public-${var.environment}"
  }
  private_subnet_tags_vpc_var = {
    NetworkSubnet = "vpc-private-${var.environment}"
  }
  database_subnet_tags_vpc_var = {
    NetworkSubnet = "vpc-database-${var.environment}"
  }
  vpn_subnet_tags_vpc_var = {
    NetworkSubnet = "vpc-vpn-${var.environment}"
  }
  elasticache_subnet_tags_vpc_var = {
    NetworkSubnet = "vpc-elasticcache-${var.environment}"
  }
}
module "ecs" {
  source = "./modules-sns/ecs"
  ecs_aws_ami_ecs_var = "${var.ami}"
  instance_type_ecs_var = "${var.instance_type}"
  max_size_ecs_var = "${var.max_size}"
  min_size_ecs_var = "${var.min_size}"
  desired_capacity_ecs_var = "${var.desired_capacity}"
  availability_zones_ecs_var = "${var.az_aws}"
  name_ecs_var = "snsproxy"
  vpc_id_vpc_out = "${module.vpc.vpc_id_vpc_out}"
  key_name_ecs_var = "${var.bastion_key_name}"
  private_subnet_ids_vpc_out = "${module.vpc.private_subnet_ids_vpc_out}"
  public_subnet_ids_vpc_out = "${module.vpc.public_subnet_ids_vpc_out}"
  branches_ecs_var = "${var.branches}"
  _prefix_ecs_var = "${var.environment}"
  _route53_discovery_zone_ecs_var = "signnow.ecs"
}

module "ecs_traefik" {
    source = "./modules-sns/ecs_traefik"
    cluster_name_ecs_out = "${module.ecs.cluster_name_ecs_out}"
    cluster_arns_ecs_out = "${module.ecs.cluster_arns_ecs_out}"
    cluster_ids_ecs_out  =  "${module.ecs.cluster_ids_ecs_out}"
    size_ingress_traefik_var = 1
    vpc_id_vpc_out = "${module.vpc.vpc_id_vpc_out}"
    public_subnet_ids_vpc_out = "${module.vpc.public_subnet_ids_vpc_out}"
    vpc_cidr_vpn_subnet_vpc_out = ["${var.vpn_subnet_cidr}"]

    route53_zone_ingress_traefik_var = "sig.ecs."
    route53_wildcard_zone_ingress_traefik_var = "sig.ecs"
    instance_security_group_id_ecs_out = "${module.ecs.cluster_instance_security_group_id_ecs_out}"
    kms_master_key_arn_vpc_out = "${module.vpc.kms_master_key_arn_vpc_out}"
}
