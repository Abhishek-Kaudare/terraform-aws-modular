resource "aws_instance" "linux_instance" {
    ami                   = var.amis
    subnet_id             = var.subnet_id
    security_groups       = var.security_groups
    instance_type         = var.instance_type
    key_name              = var.key_name
    iam_instance_profile  = var.role
    availability_zone     = var.availability_zone
    user_data             = var.user_data
    # Name the instance
    tags = {
        Name = "${var.instanceName}"
    }
}

