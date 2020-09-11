resource "aws_security_group" "security_group_demo" {
    vpc_id       = var.vpc_id
    name         = var.sg_name
    tags = {
        Name = "${var.sg_name}"
    }
}
