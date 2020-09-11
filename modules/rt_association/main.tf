# Associate subnet public_subnet to public route table
resource "aws_route_table_association" "association_demo" {
    subnet_id = var.subnet_id
    route_table_id = var.route_table_id
}