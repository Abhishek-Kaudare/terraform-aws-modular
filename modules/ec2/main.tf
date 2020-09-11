resource "aws_instance" "linux_instance" {
    ami                   = var.amis
    subnet_id             = var.subnet
    security_groups       = var.securityGroup
    instance_type         = var.instanceType
    key_name              = var.key_name
    iam_instance_profile  = var.role
    availability_zone     = var.az
    # Name the instance
    tags = {
        Name = var.instanceName
    }
}

