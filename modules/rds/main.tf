# RDS Instance
resource "aws_db_instance" "rds_demo" {
    identifier              = var.identifier
    availability_zone       = var.availability_zone

    # Network Vars
    db_subnet_group_name    = var.db_subnet_group_name
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
    name                    = var.db_name
    username                = var.username
    password                = var.password
    port                    = var.port

    # Security And Accessibility
    publicly_accessible     = var.publicly_accessible
    vpc_security_group_ids  = var.vpc_security_group_ids

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