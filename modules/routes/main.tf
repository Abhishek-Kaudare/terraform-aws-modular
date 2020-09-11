# Route to the internet
resource "aws_route" "route_demo" {
  route_table_id         = var.rt_id
  destination_cidr_block = var.cidr_block
  gateway_id             = var.ig_id
  nat_gateway_id         = var.nat_id
}
