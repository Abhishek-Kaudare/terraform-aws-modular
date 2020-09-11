
# RDS Variables
variable "identifier" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "db_subnet_group_name" {
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

variable "vpc_security_group_ids" {
  type = list
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