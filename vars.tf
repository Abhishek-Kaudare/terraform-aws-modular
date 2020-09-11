variable "region" {
    type = string
}
variable "availability_zone" {
    type = string
}
variable "availability_zone_b" {
    type = string
}
variable "name_prefix" {
    type = string
}

# vpc vars
variable "cidr" {
    type = string
}
variable "dns_support_bool" {
    type = bool
}
variable "dns_hostnames_bool" {
    type = bool
}

# route vars
variable "internet_cidr_block" {
    type = string
}

# pub subnet vars
variable "map_public_ip_on_launch_bool_pub" {
    type = bool
}

# pub subnet vars
variable "map_public_ip_on_launch_bool_pvt" {
    type = bool
}

# ec2 Variables 
variable "amis" {
    type = string
}
variable "instance_type" {
    type = string
}
variable "key_name" {
    type = string
}
variable "role" {
    type = string
}

# DSG Variables
variable "dsg_name" {
    type = string
}

# RDS Variables
variable "identifier" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "backup_retention_period" {
  type = number
}

variable "backup_window" {
  type = string
}

variable "maintenance_window" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "multi_az" {
  type = bool
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "port" {
  type = number
}

variable "publicly_accessible" {
  type = bool
}

variable "storage_encrypted" {
  type = bool
}

variable "storage_type" {
  type = string
}

variable "allow_major_version_upgrade" {
  type = bool
}

variable "auto_minor_version_upgrade" {
  type = bool
}

variable "final_snapshot_identifier" {
  type = string
}

variable "snapshot_identifier" {
  type = string
}

variable "skip_final_snapshot" {
  type = bool
}