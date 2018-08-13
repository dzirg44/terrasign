#----------------------
# Module creates a vpc 
#----------------------

variable "name_vpc_var" {
  description = "Define Environment"
  default     = ""
}

variable "cidr_vpc_var" {
  description = "CIDR block for the own VPC"
  default     = ""
}
// https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/dedicated-instance.html
variable "instance_tenancy_vpc_var" {
  description = "Select instance type in the VPC. Can be  | default | dedicated | host, see above for more information"
  default     = "default"
}

variable "public_subnets_vpc_var" {
  description = "VPC public subnets."
  default     = []
}

variable "private_subnets_vpc_var" {
  description = "VPC private subnets."
  default     = []
}

variable "vpn_subnet_vpc_var" {
  description = "VPN subnet in the VPC"
  default     = ""
}

variable "database_subnets_vpc_var" {
  type        = "list"
  description = "VPC database subnets"
  default     = []
}

variable "elasticache_subnets_vpc_var" {
  type        = "list"
  description = "VPC elasticache subnets"
  default     = []
}

variable "azs_vpc_var" {
  description = "VPC Availability zones in selected region"
  default     = []
}

variable "enable_dns_hostnames_vpc_var" {
  description = "Set 'true' for using private 'DNS'"
  default     = false
}

variable "enable_dns_support_vpc_var" {
  description = "Set 'true' for using private 'DNS'"
  default     = false
}

variable "enable_nat_gateway_vpc_var" {
  description = "Set 'true' for NAT Gateways for every your private network"
  default     = false
}

variable "single_nat_gateway_vpc_var" {
  description = "Set 'true' for single(shared) NAT Gateway for all yours private network"
  default     = false
}

variable "enable_s3_endpoint_vpc_var" {
  description = "Set 'true' for S3 endpoint in the VPC"
  default     = false
}

variable "enable_ipv6_vpc_var" {
  description = "Set 'true' for IPv6 support"
  default     = false
}

variable "map_public_ip_on_launch_vpc_var" {
  description = "Set 'true' if you want to auto-assign public IP"
  default     = true
}

variable "private_propagating_vgws_vpc_var" {
  description = "VPC VGWs the private route table"
  default     = []
}

variable "public_propagating_vgws_vpc_var" {
  description = "VPC VGWs the public route table"
  default     = []
}

variable "vpn_propagating_vgws_vpc_var" {
  description = "VPC VGWs the vpn route table"
  default     = []
}

variable "create_vpn_vpc_var" {
  description = "Create VPC VPN resources"
  default     = true
}

#! PV
variable "_kms_deletion_window_in_days_vpc_var" {
  default = 30
}
