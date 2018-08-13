##############################################################
# DEFINE VPC
##############################################################
resource "aws_vpc" "myvpc" {
  cidr_block           = "${var.cidr_vpc_var}"
  instance_tenancy     = "${var.instance_tenancy_vpc_var}"
  enable_dns_hostnames = "${var.enable_dns_hostnames_vpc_var}"
  enable_dns_support   = "${var.enable_dns_support_vpc_var}"
  tags                 = "${merge(var._tags_vpc_var, var.tags_vpc_var, map("Name", format("%s", var.name_vpc_var)))}"

  assign_generated_ipv6_cidr_block = "${var.enable_ipv6_vpc_var}"
}

#############################################################
# INTERNET GATEWAY LAYER
#############################################################
resource "aws_internet_gateway" "myvpc" {
  vpc_id = "${aws_vpc.myvpc.id}"
  tags   = "${merge(var._tags_vpc_var, var.tags_vpc_var, map("Name", format("%s-igw", var.name_vpc_var)))}"
}
resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.myvpc.id}"
}
##############################################################
# VPN LAYER
##############################################################
resource "aws_route" "vpn_internet_gateway" {
  count                  = "${var.create_vpn_vpc_var}"
  route_table_id         = "${aws_route_table.vpn.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.myvpc.id}"
}

resource "aws_route_table" "vpn" {
  count            = "${var.create_vpn_vpc_var}"
  vpc_id           = "${aws_vpc.myvpc.id}"
  propagating_vgws = ["${var.vpn_propagating_vgws_vpc_var}"]
  tags             = "${merge(var._tags_vpc_var, var.tags_vpc_var, map("Name", format("%s-vpn", var.name_vpc_var)))}"
}
resource "aws_subnet" "vpn" {
  count      = "${var.create_vpn_vpc_var}"
  vpc_id     = "${aws_vpc.myvpc.id}"
  cidr_block = "${var.vpn_subnet_vpc_var}"
  tags       = "${merge(var._tags_vpc_var, var.tags_vpc_var, var.vpn_subnet_tags_vpc_var, map("Name", format("%s-vpn-%s", var.name_vpc_var, element(var.azs_vpc_var, 0))))}"
}
resource "aws_route_table_association" "vpn" {
  count          = "${var.create_vpn_vpc_var}"
  subnet_id      = "${aws_subnet.vpn.id}"
  route_table_id = "${aws_route_table.vpn.id}"
}
###########################################################
# PUBLIC NETWORK LAYER
###########################################################
resource "aws_route_table" "public" {
  vpc_id           = "${aws_vpc.myvpc.id}"
  propagating_vgws = ["${var.public_propagating_vgws_vpc_var}"]
  tags             = "${ merge(var._tags_vpc_var, var.tags_vpc_var, map("Name", format("%s-public", var.name_vpc_var)))}"
}
resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.myvpc.id}"
  cidr_block        = "${var.public_subnets_vpc_var[count.index]}"
  availability_zone = "${element(var.azs_vpc_var, count.index)}"
  count             = "${length(var.public_subnets_vpc_var)}"
  tags              = "${merge(var._tags_vpc_var, var.tags_vpc_var, var.public_subnet_tags_vpc_var, map("Name", format("%s-public-%s", var.name_vpc_var, element(var.azs_vpc_var, count.index))))}"

  map_public_ip_on_launch = "${var.map_public_ip_on_launch_vpc_var}"
}
resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets_vpc_var)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

###########################################################
# PRIVATE NETWORK LAYER
###########################################################
resource "aws_route_table" "private" {
  vpc_id           = "${aws_vpc.myvpc.id}"
  propagating_vgws = ["${var.private_propagating_vgws_vpc_var}"]
  count            = "${length(var.azs_vpc_var)}"
  tags             = "${merge(var._tags_vpc_var, var.tags_vpc_var, map("Name", format("%s-private-%s", var.name_vpc_var, element(var.azs_vpc_var, count.index))))}"
}
resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.myvpc.id}"
  cidr_block        = "${var.private_subnets_vpc_var[count.index]}"
  availability_zone = "${element(var.azs_vpc_var, count.index)}"
  count             = "${length(var.private_subnets_vpc_var)}"
  tags              = "${merge(var._tags_vpc_var, var.tags_vpc_var, var.private_subnet_tags_vpc_var, map("Name", format("%s-private-%s", var.name_vpc_var, element(var.azs_vpc_var, count.index))))}"
}
resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets_vpc_var)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

################################################################
# DATABASE NETWORK LAYER
################################################################
resource "aws_subnet" "database" {
  vpc_id            = "${aws_vpc.myvpc.id}"
  cidr_block        = "${var.database_subnets_vpc_var[count.index]}"
  availability_zone = "${element(var.azs_vpc_var, count.index)}"
  count             = "${length(var.database_subnets_vpc_var)}"
  tags              = "${merge(var._tags_vpc_var, var.tags_vpc_var, var.database_subnet_tags_vpc_var, map("Name", format("%s-database-%s", var.name_vpc_var, element(var.azs_vpc_var, count.index))))}"
}
resource "aws_db_subnet_group" "database" {
  name        = "${var.name_vpc_var}-rds"
  description = "Database subnet groups for ${var.name_vpc_var}"
  subnet_ids  = ["${aws_subnet.database.*.id}"]
  tags        = "${merge(var._tags_vpc_var, var.tags_vpc_var, map("Name", format("%s-database", var.name_vpc_var)))}"
  count       = "${length(var.database_subnets_vpc_var) > 0 ? 1 : 0}"
}

resource "aws_route_table_association" "database" {
  count          = "${length(var.database_subnets_vpc_var)}"
  subnet_id      = "${element(aws_subnet.database.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

#####################################################################
# ELASTIC CACHE LAYER
#####################################################################
resource "aws_subnet" "elasticache" {
  vpc_id            = "${aws_vpc.myvpc.id}"
  cidr_block        = "${var.elasticache_subnets_vpc_var[count.index]}"
  availability_zone = "${element(var.azs_vpc_var, count.index)}"
  count             = "${length(var.elasticache_subnets_vpc_var)}"
  tags              = "${merge(var._tags_vpc_var, var.tags_vpc_var, var.elasticache_subnet_tags_vpc_var, map("Name", format("%s-elasticache-%s", var.name_vpc_var, element(var.azs_vpc_var, count.index))))}"
}
resource "aws_elasticache_subnet_group" "elasticache" {
  name        = "${var.name_vpc_var}-elasticache"
  description = "Elasticache subnet groups for ${var.name_vpc_var}"
  subnet_ids  = ["${aws_subnet.elasticache.*.id}"]
  count       = "${length(var.elasticache_subnets_vpc_var) > 0 ? 1 : 0}"
}
resource "aws_route_table_association" "elasticache" {
  count          = "${length(var.elasticache_subnets_vpc_var)}"
  subnet_id      = "${element(aws_subnet.elasticache.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}
##############################################################
# NAT LAYER
##############################################################
resource "aws_eip" "nateip" {
  vpc   = true
  count = "${var.enable_nat_gateway_vpc_var ? (var.single_nat_gateway_vpc_var ? 1 : length(var.azs_vpc_var)) : 0}"
}
resource "aws_nat_gateway" "natgw" {
  allocation_id = "${element(aws_eip.nateip.*.id, (var.single_nat_gateway_vpc_var ? 0 : count.index))}"
  subnet_id     = "${element(aws_subnet.public.*.id, (var.single_nat_gateway_vpc_var ? 0 : count.index))}"
  count         = "${var.enable_nat_gateway_vpc_var ? (var.single_nat_gateway_vpc_var ? 1 : length(var.azs_vpc_var)) : 0}"

  depends_on = ["aws_internet_gateway.myvpc", "aws_route_table.private"]
}
resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
  count                  = "${var.enable_nat_gateway_vpc_var ? length(var.azs_vpc_var) : 0}"
}
#############################################################
# S3 LAYER
#############################################################
data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
}
resource "aws_vpc_endpoint" "ep" {
  vpc_id       = "${aws_vpc.myvpc.id}"
  service_name = "${data.aws_vpc_endpoint_service.s3.service_name}"
  count        = "${var.enable_s3_endpoint_vpc_var}"
}
resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count           = "${var.enable_s3_endpoint_vpc_var ? length(var.private_subnets_vpc_var) : 0}"
  vpc_endpoint_id = "${aws_vpc_endpoint.ep.id}"
  route_table_id  = "${element(aws_route_table.private.*.id, count.index)}"
}
resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  count           = "${var.enable_s3_endpoint_vpc_var ? length(var.public_subnets_vpc_var) : 0}"
  vpc_endpoint_id = "${aws_vpc_endpoint.ep.id}"
  route_table_id  = "${aws_route_table.public.id}"
}


