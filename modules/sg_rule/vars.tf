variable "type" {
    type = string
}
variable "cidr_blocks" {
    type = list
}
variable "from_port" {
    type = number
}
variable "to_port" {
    type = number
}
variable "protocol" {
    type = string
}
variable "sg_id" {
    type = string
}