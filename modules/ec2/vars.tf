# ec2 Variables 
variable "amis" {
    type = string
}
variable "subnet_id" {
    type = string
}
variable "security_groups" {
    type = list
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
variable "availability_zone" {
    type = string
}
variable "user_data" {
    type = string
}
variable "instanceName" {
    type = string
}