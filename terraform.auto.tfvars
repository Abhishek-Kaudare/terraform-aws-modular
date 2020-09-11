# provider vars
region = "us-east-1"
name_prefix = "abhishek-terraform"
availability_zone = "us-east-1a"
availability_zone_b = "us-east-1b"
# vpc vars
cidr = "10.0.0.0/16"
dns_support_bool = true
dns_hostnames_bool = true
# public subnet
map_public_ip_on_launch_bool_pub = true
# private subnet
map_public_ip_on_launch_bool_pvt = false
# route vars
internet_cidr_block = "0.0.0.0/0"




# az1 = "us-east-1b"
# cidr = "10.0.0.0/16"

# # ec2 Variables 
# amis = "ami-0c94855ba95c71c99"
# instanceType = "t2.micro"
# instanceName = "terraform-21046-abhishek"
# key_name = "abhishek_21046"
# role = "FE-Fresher-EC2"

# # DSG Variables
# dsg_name = "abhishek-dsg"

# # RDS Variables
# identifier = "abhishek-mysql"
# allocated_storage = 10
# backup_retention_period = 1
# backup_window = "10:46-11:16"
# maintenance_window = "Mon:00:00-Mon:03:00"
# engine = "mysql"
# engine_version = "8.0.15"
# instance_class = "db.t2.micro"
# multi_az = false
# username = "admin"
# password = "password"
# port = 3306
# publicly_accessible = false
# storage_encrypted = false
# storage_type = "gp2"
# allow_major_version_upgrade = true
# auto_minor_version_upgrade = false
# final_snapshot_identifier = "prod-trademerch-website-db-snapshot"
# snapshot_identifier = null
# skip_final_snapshot = true
# db_name = "abhishek_terraform"