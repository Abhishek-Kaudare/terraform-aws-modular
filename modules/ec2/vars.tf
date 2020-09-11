# Common Variables
variable "region" {
    type = string
}
variable "az" {
    type = string
}

# ec2 Variables 
variable "instanceType" {
    type = string
}
variable "subnet" {
    type = string
}
variable "securityGroup" {
    type = list
}
variable "instanceName" {
    type = string
}
variable "amis" {
    type = string
}
variable "key_name" {
    type = string
}
variable "role" {
    type = string
}