

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
