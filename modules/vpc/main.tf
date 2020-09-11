resource "aws_vpc" "vpc_demo" {
  cidr_block = var.cidr
  enable_dns_support = var.dns_support_bool
  enable_dns_hostnames = var.dns_hostnames_bool
  tags = {
    Name = "${var.vpc_name}"
  }
}






