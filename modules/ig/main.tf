
# Internet gateway
resource "aws_internet_gateway" "ig_demo" {
    vpc_id = var.vpc_id
    tags = {
            Name = "${var.ig_name}"
        }
}
