# Public subnet
resource "aws_subnet" "subnet_demo" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.cidr_block
  map_public_ip_on_launch = var.map_public_ip_on_launch_bool # public_true private_false
  availability_zone       = var.availability_zone
  tags = {
  	Name =  "${var.subnet_name}"
  }
}