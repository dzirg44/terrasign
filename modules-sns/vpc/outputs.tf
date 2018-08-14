############################################
# VPC IDS OUT
############################################
output "vpc_id_vpc_out" {
  value = "${aws_vpc.myvpc.id}"
}
output "vpc_cidr_vpc_out" {
	value = ["${var.cidr_vpc_var}"]
}
output "default_security_group_id_vpc_out" {
  value = "${aws_vpc.myvpc.default_security_group_id}"
}
############################################
# INTERNET GATEWAY OUT
############################################
output "igw_id_vpc_out" {
  value = "${aws_internet_gateway.myvpc.id}"
}
############################################
# NAT OUT
############################################
output "nat_eips_vpc_out" {
  value = ["${aws_eip.nateip.*.id}"]
}

output "nat_eips_public_ips_vpc_out" {
  value = ["${aws_eip.nateip.*.public_ip}"]
}

output "natgw_private_ips_vpc_out" {
  value = ["${aws_nat_gateway.natgw.*.private_ip}"]
}

output "natgw_ids_vpc_out" {
  value = ["${aws_nat_gateway.natgw.*.id}"]
}

############################################
# PUBLIC SUBNET OUT
############################################
output "public_subnet_ids_vpc_out" {
  value = ["${aws_subnet.public.*.id}"]
}
output "public_route_table_ids_vpc_out" {
  value = ["${aws_route_table.public.*.id}"]
}
#############################################
# PRIVATE SUBNET OUT
#############################################
output "private_subnet_ids_vpc_out" {
  value = ["${aws_subnet.private.*.id}"]
}
output "private_route_table_ids_vpc_out" {
  value = ["${aws_route_table.private.*.id}"]
}
#############################################
# VPN SUBNET OUT
#############################################
output "vpn_subnet_id_vpc_out" {
  value = "${length(aws_subnet.vpn.*.id) > 0 ? element(concat(aws_subnet.vpn.*.id, list("")), 0) : ""}"
}
output "vpn_route_table_ids_vpc_out" {
  value = "${aws_route_table.vpn.*.id}"
}
#############################################
# DATABASE SUBNET OUT
#############################################
output "database_subnets_vpc_out" {
  value = ["${aws_subnet.database.*.id}"]
}
output "database_subnet_group_vpc_out" {
  value = ["${aws_db_subnet_group.database.*.id}"]
}
##############################################
# ELASTIC CACHE SUBNET OUT
##############################################
output "elasticache_subnets_vpc_out" {
  value = ["${aws_subnet.elasticache.*.id}"]
}
output "elasticache_subnet_group_vpc_out" {
  value = "${aws_elasticache_subnet_group.elasticache.*.id}"
}
###############################################
# KMS OUT
###############################################
output "kms_master_key_arn_vpc_out" {
  value = "${aws_kms_key.master.arn}"
}

output "kms_master_key_id_vpc_out" {
  value = "${aws_kms_key.master.id}"
}

output "kms_master_key_alias_vpc_out" {
  value = "${aws_kms_alias.master_alias.id}"
}