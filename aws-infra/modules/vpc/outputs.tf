output "vpc_id" {
    value = aws_vpc.test-vpc.id
}

output "public_subnets1_id" {
    value = aws_subnet.pub_subnet1.id
}

output "public_subnets2_id" {
    value = aws_subnet.pub_subnet2.id
}

output "private_subnets1_id" {
    value = aws_subnet.priv_subnet1.id
}