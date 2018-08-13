resource "aws_kms_key" "master" {
  description             = "${var.name_vpc_var}"
  deletion_window_in_days = "${var._kms_deletion_window_in_days_vpc_var}"
}

resource "aws_kms_alias" "master_alias" {
  name          = "alias/${var.name_vpc_var}"
  target_key_id = "${aws_kms_key.master.id}"
}
