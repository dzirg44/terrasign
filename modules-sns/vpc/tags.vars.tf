#-----------------------------------
# Variables to creates tags on vpc # 
#-----------------------------------

variable "tags_vpc_var" {
  description = "You can to add map of tags to all resources"
  default     = {}
}

variable "public_subnet_tags_vpc_var" {
  description = "You can add tags for the public subnets"
  default     = {}
}

variable "private_subnet_tags_vpc_var" {
  description = "You can add tags for the public subnets"
  default     = {}
}

variable "database_subnet_tags_vpc_var" {
  description = "You can add tags for the database RDS subnets"
  default     = {}
}

variable "vpn_subnet_tags_vpc_var" {
  description = "You can add tags for the VPN subnet"
  default     = {}
}

variable "elasticache_subnet_tags_vpc_var" {
  description = "You can add tags for the elasticache subnets"
  default     = {}
}

# !private
variable "_tags_vpc_var" {
  default = {
    terraform = "true"
  }
}
