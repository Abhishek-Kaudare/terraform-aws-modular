resource "aws_nat_gateway" "nat_demo" {
    allocation_id = var.eip_id
    subnet_id = var.subnet_id
    tags = {
        Name = "${var.nat_name}"
    }
}
