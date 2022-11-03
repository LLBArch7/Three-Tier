variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "aws_ami" {}
variable "aws_instance_type" {}
variable "aws_key" {}
variable "aws_public_subnets1" {
    default = "172.19.0.0/18"
}
variable "aws_private_subnets1" {
    default = "172.19.128.0/18"
}
variable "aws_public_subnets2" {
    default = "172.19.64.0/18"
}
variable "aws_private_subnets2" {
    default = "172.19.192.0/18"
}
variable "aws_main_vpc_cidr" {
    default = "172.19.0.0/16"
}