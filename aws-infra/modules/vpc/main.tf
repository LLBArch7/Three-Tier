# VPC
resource "aws_vpc" "test-vpc" {
    cidr_block           = var.main_vpc_cidr
    enable_dns_hostnames = "true"

    tags = {
        "Name" : "Three-Tier"
    }
}
 
# ELASTIC IP
resource "aws_eip" "nat_eip_prob" {
    vpc = true

}

# PUBLIC SUBNET 1
resource "aws_subnet" "pub_subnet1" {
    cidr_block              = var.public_subnets1
    vpc_id                  = aws_vpc.test-vpc.id
    map_public_ip_on_launch = "true"
    availability_zone       = var.availability_zones_data.names[0]
}

# PRIVATE SUBNET 1
resource "aws_subnet" "priv_subnet1" {
    cidr_block              = var.private_subnets1
    vpc_id                  = aws_vpc.test-vpc.id
    map_public_ip_on_launch = "false"
    availability_zone       = var.availability_zones_data.names[0]
}

# PUBLIC SUBNET 2
resource "aws_subnet" "pub_subnet2" {
    cidr_block              = var.public_subnets2
    vpc_id                  = aws_vpc.test-vpc.id
    map_public_ip_on_launch = "true"
    availability_zone       = var.availability_zones_data.names[1]
}
 
# PRIVATE SUBNET 2
resource "aws_subnet" "priv_subnet2" {
    cidr_block              = var.private_subnets2
    vpc_id                  = aws_vpc.test-vpc.id
    map_public_ip_on_launch = "false"
    availability_zone       = var.availability_zones_data.names[1]
}

# NAT GATEWAY
resource "aws_nat_gateway" "nat_gateway_prob" {
    allocation_id = aws_eip.nat_eip_prob.id
    subnet_id     = aws_subnet.pub_subnet1.id
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "gw_1" {
    vpc_id = aws_vpc.test-vpc.id
}

# ROUTE TABLE
resource "aws_route_table" "route_table1" {
    vpc_id = aws_vpc.test-vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw_1.id
    }
}

resource "aws_route_table_association" "route-subnet1" {
    subnet_id      = aws_subnet.pub_subnet1.id
    route_table_id = aws_route_table.route_table1.id
}

# ROUTE TABLE
resource "aws_route_table" "route_table2" {
    vpc_id = aws_vpc.test-vpc.id
 
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw_1.id
    }
}

resource "aws_route_table_association" "route-subnet2" {
    subnet_id      = aws_subnet.pub_subnet2.id
    route_table_id = aws_route_table.route_table2.id
}
