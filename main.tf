module "vpc" {
    source              = "./modules/vpc"
    cidr                = var.cidr
    dns_support_bool    = var.dns_support_bool
    dns_hostnames_bool  = var.dns_hostnames_bool
    vpc_name            = "${var.name_prefix}-vpc"
}

# Public subnet
module "public_subnet" {
    source                          = "./modules/subnet"
    vpc_id                          = module.vpc.vpc_id
    cidr_block                      = cidrsubnet(var.cidr, 8, 1)
    map_public_ip_on_launch_bool    = var.map_public_ip_on_launch_bool_pub
    availability_zone               = var.availability_zone
    subnet_name                     = "${var.name_prefix}-subnet-pub"
}

# Private subnets
module "private_1_subnet" {
    source                          = "./modules/subnet"
    vpc_id                          = module.vpc.vpc_id
    cidr_block                      = cidrsubnet(var.cidr, 8, 2)
    map_public_ip_on_launch_bool    = var.map_public_ip_on_launch_bool_pvt
    availability_zone               = var.availability_zone
    subnet_name                     = "${var.name_prefix}-subnet-pvt-1"
}
module "private_2_subnet" {
    source                          = "./modules/subnet"
    vpc_id                          = module.vpc.vpc_id
    cidr_block                      = cidrsubnet(var.cidr, 8, 3)
    map_public_ip_on_launch_bool    = var.map_public_ip_on_launch_bool_pvt
    availability_zone               = var.availability_zone_b
    subnet_name                     = "${var.name_prefix}-subnet-pvt-2"
}

# Internet gateway
module "igw" {
    source  = "./modules/ig"
    vpc_id  = module.vpc.vpc_id
    ig_name = "${var.name_prefix}-InternetGateway"
}

# NAT Gateway
resource "aws_eip" "demo_eip" {
    vpc      = true
    depends_on = [module.igw]
}
module "nat" {
    source      = "./modules/nat"
    eip_id      = aws_eip.demo_eip.id
    subnet_id   = module.public_subnet.subnet_id
    nat_name    = "${var.name_prefix}-NAT"
}

# Private route table
module "private_route_table" {
    source  = "./modules/rt"
    vpc_id  = module.vpc.vpc_id
    rt_name = "${var.name_prefix}-Pvt-RT"
}

# Route to the internet
module "internet_access" {
    source      = "./modules/routes"
    rt_id       = module.vpc.vpc_route_table_id
    cidr_block  = var.internet_cidr_block
    ig_id       = module.igw.ig_id
    nat_id      = ""
}
module "private_route" {
    source          = "./modules/routes"
	rt_id           = module.private_route_table.rt_id
	cidr_block      = var.internet_cidr_block
    ig_id           = ""
	nat_id          = module.nat.nat_id
}

# Associate subnet public_subnet to public route table
module "public_subnet_association" {
    source          = "./modules/rt_association"
    subnet_id       = module.public_subnet.subnet_id
    route_table_id  = module.vpc.vpc_route_table_id
}

# Associate subnet private_1_subnet to private route table
module "pvt_1_subnet_association" {
    source          = "./modules/rt_association"
    subnet_id       = module.private_1_subnet.subnet_id
    route_table_id  = module.private_route_table.rt_id
}

# Associate subnet private_2_subnet to private route table
module "pvt_2_subnet_association" {
    source          = "./modules/rt_association"
    subnet_id       = module.private_2_subnet.subnet_id
    route_table_id  = module.private_route_table.rt_id
}

# # Create the Security Group
# resource "aws_security_group" "VPC_Security_Group" {
#     vpc_id       = aws_vpc.vpc_demo.id
#     name         = "${var.name_prefix}-sg"
    
#     # allow ingress of port 22
#     ingress {
#         cidr_blocks = ["0.0.0.0/0"]
#         from_port   = 22
#         to_port     = 22
#         protocol    = "tcp"
#     }

#     # allow egress of all ports
#     egress {
#         from_port   = 0
#         to_port     = 0
#         protocol    = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
#     tags = {
#         Name = "${var.name_prefix}-sg"
#     }
# }



# resource "aws_security_group_rule" "from_sg" {
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   source_security_group_id = aws_security_group.VPC_Security_Group.id
#   security_group_id = aws_security_group.VPC_Security_Group.id
# }


# # Aws Public Instance
# resource "aws_instance" "public_instance" {
#     ami                   = var.amis
#     subnet_id             = aws_subnet.public_subnet.id
#     security_groups       = [aws_security_group.VPC_Security_Group.id]
#     instance_type         = var.instanceType
#     key_name              = var.key_name
#     iam_instance_profile  = var.role
#     availability_zone     = var.az
#     # Name the instance
#     tags = {
#         Name = "${var.name_prefix}-pub-instance"
#     }
# }

# # Aws Private Instance
# resource "aws_instance" "private_1_instance" {
#     ami                   = var.amis
#     subnet_id             = aws_subnet.private_1_subnet.id
#     security_groups       = [aws_security_group.VPC_Security_Group.id]
#     instance_type         = var.instanceType
#     key_name              = var.key_name
#     iam_instance_profile  = var.role
#     availability_zone     = var.az
#     user_data             = data.template_cloudinit_config.config.rendered
#     # Name the instance
#     tags = {
#         Name = "${var.name_prefix}-pvt-1-instance"
#     }
# }

# # Create subnet group for RDS
# resource "aws_db_subnet_group" "default_group" {
#     name       = var.dsg_name
#     subnet_ids = [aws_subnet.private_1_subnet.id,aws_subnet.private_2_subnet.id]
# }

# # RDS Instance
# resource "aws_db_instance" "rds" {
#     identifier = var.identifier
#     availability_zone = var.az

#     # Network Vars
#     db_subnet_group_name    = aws_db_subnet_group.default_group.name
#     allocated_storage       = var.allocated_storage

#     # Backups
#     backup_retention_period = var.backup_retention_period
#     backup_window           = var.backup_window
#     maintenance_window      = var.maintenance_window

#     # Engine and Instance Types
#     engine                  = var.engine
#     engine_version          = var.engine_version
#     instance_class          = var.instance_class
#     multi_az                = var.multi_az

#     # Credentials
#     name                    = var.db_name
#     username                = var.username
#     password                = var.password
#     port                    = var.port

#     # Security And Accessibility
#     publicly_accessible     = var.publicly_accessible
#     vpc_security_group_ids  = [aws_security_group.VPC_Security_Group.id]

#     # Storage Conf
#     storage_encrypted       = var.storage_encrypted
#     storage_type            = var.storage_type

#     # Maintainance
#     allow_major_version_upgrade = var.allow_major_version_upgrade
#     auto_minor_version_upgrade  = var.auto_minor_version_upgrade

#     # Snapshots
#     final_snapshot_identifier = var.final_snapshot_identifier
#     snapshot_identifier       = var.snapshot_identifier
#     skip_final_snapshot       = var.skip_final_snapshot
# }