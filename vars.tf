variable "environment" {
  description = "Define envirinment for all project"
  default = "snsproxy"
}
variable "region" {
  description = "Define current region"
  default = "eu-central-1"
}

variable "az_aws" {
  description = "Available zones"
  default = [
      "eu-central-1a",
      "eu-central-1b",
      "eu-central-1c"
    ]
}

variable "public_subnet_cidrs" {
description = "public subnet"
default = ["10.0.0.0/24", "10.0.1.0/24"]

}

variable "private_subnet_cidrs" {
description = "private subnet"
default = ["10.0.50.0/24", "10.0.51.0/24"]

}
variable "vpn_subnet_cidr" {
description = "vpn subnet"
default = "10.0.100.0/24"

}
variable "branches" {
  type = "list"

  default = [
    "master",
    "develop",
  ]
}

variable "certificate_arns" {
  type = "list"

  default = [
    "arn:aws:acm:eu-central-1:947694726085:certificate/3fbfb4b9-1a61-400e-bd92-6c95b68c1ad4",
  ]
}
variable "domain_list" {
  description = "List of domains to get certificates for"
	type = "list"
  default = [
    "signnow.ecs",
  ]
}

variable "bastion_key_name" {
  default   = "dzirg444"
  
}
