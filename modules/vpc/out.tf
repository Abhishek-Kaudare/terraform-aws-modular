output "vpc_id" {
  value = aws_vpc.vpc_demo.id
}

output "vpc_route_table_id" {
  value = aws_vpc.vpc_demo.main_route_table_id
}