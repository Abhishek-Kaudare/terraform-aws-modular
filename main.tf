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

# Create the Security Group
module "VPC_Security_Group" {
    source  = "./modules/sg"
    vpc_id  = module.vpc.vpc_id
    sg_name = "${var.name_prefix}-sg"
}

# SG Rules
module "from_sg" {
    source       = "./modules/sg_rule"
    type         = "ingress"
    cidr_blocks  = ""
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    source_sg_id = module.VPC_Security_Group.sg_id
    sg_id        = module.VPC_Security_Group.sg_id
}
module "ssh_all_ingress" {
    source       = "./modules/sg_rule"
    type         = "ingress"
    cidr_blocks  = [internet_cidr_block]
    from_port    = 22
    to_port      = 22
    protocol     = "tcp"
    source_sg_id = module.VPC_Security_Group.sg_id
    sg_id        = ""
}
module "all_egress" {
    source       = "./modules/sg_rule"
    type         = "egress"
    cidr_blocks  = [internet_cidr_block]
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    source_sg_id = module.VPC_Security_Group.sg_id
    sg_id        = ""
}

# Public Instance
module "public_instance" {
    source              = "./modules/ec2"
    amis                = var.amis
    subnet_id           = module.public_subnet.subnet_id
    security_groups     = [module.VPC_Security_Group.sg_id]
    instance_type       = var.instance_type
    key_name            = var.key_name
    role                = var.role
    availability_zone   = var.availability_zone
    user_data           = ""
    instanceName        = "${var.name_prefix}-pub-instance"
}

# Private Instance
module "private_instance" {
    source              = "./modules/ec2"
    amis                = var.amis
    subnet_id           = module.private_1_subnet.subnet_id
    security_groups     = [module.VPC_Security_Group.sg_id]
    instance_type       = var.instance_type
    key_name            = var.key_name
    role                = var.role
    availability_zone   = var.availability_zone
    user_data           = data.template_cloudinit_config.config.rendered
    instanceName        = "${var.name_prefix}-pvt-instance"
}

# Create subnet group for RDS
resource "aws_db_subnet_group" "default_group" {
    name       = var.dsg_name
    subnet_ids = [module.private_1_subnet.subnet_id,module.private_1_subnet.subnet_id]
}

# RDS Instance
module "rds" {
    source                  = "./modules/rds"

    identifier              = var.identifier
    availability_zone       = var.availability_zone

    # Network Vars
    db_subnet_group_name    = aws_db_subnet_group.default_group.name
    allocated_storage       = var.allocated_storage

    # Backups
    backup_retention_period = var.backup_retention_period
    backup_window           = var.backup_window
    maintenance_window      = var.maintenance_window

    # Engine and Instance Types
    engine                  = var.engine
    engine_version          = var.engine_version
    instance_class          = var.instance_class
    multi_az                = var.multi_az

    # Credentials
    db_name                 = var.db_name
    username                = var.username
    password                = var.password
    port                    = var.port

    # Security And Accessibility
    publicly_accessible     = var.publicly_accessible
    vpc_security_group_ids  = [module.VPC_Security_Group.sg_id]

    # Storage Conf
    storage_encrypted       = var.storage_encrypted
    storage_type            = var.storage_type

    # Maintainance
    allow_major_version_upgrade = var.allow_major_version_upgrade
    auto_minor_version_upgrade  = var.auto_minor_version_upgrade

    # Snapshots
    final_snapshot_identifier = var.final_snapshot_identifier
    snapshot_identifier       = var.snapshot_identifier
    skip_final_snapshot       = var.skip_final_snapshot
}