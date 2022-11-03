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
    
    tags = {
        "Name" : "Three-Tier Pub-Subnet-1"
        "Terraform" : "true"
    }
}

# PRIVATE SUBNET 1
resource "aws_subnet" "priv_subnet1" {
    cidr_block              = var.private_subnets1
    vpc_id                  = aws_vpc.test-vpc.id
    map_public_ip_on_launch = "false"
    availability_zone       = var.availability_zones_data.names[0]
    
    tags = {
        "Name" : "Three-Tier Priv-Subnet-1"
        "Terraform" : "true"
    }
}

# PUBLIC SUBNET 2
resource "aws_subnet" "pub_subnet2" {
    cidr_block              = var.public_subnets2
    vpc_id                  = aws_vpc.test-vpc.id
    map_public_ip_on_launch = "true"
    availability_zone       = var.availability_zones_data.names[1]

    tags = {
        "Name" : "Three-Tier Pub-Subnet-2"
        "Terraform" : "true"
    }
}
 
# PRIVATE SUBNET 2
resource "aws_subnet" "priv_subnet2" {
    cidr_block              = var.private_subnets2
    vpc_id                  = aws_vpc.test-vpc.id
    map_public_ip_on_launch = "false"
    availability_zone       = var.availability_zones_data.names[1]

    tags = {
        "Name" : "Three-Tier Priv-Subnet-2"
        "Terraform" : "true"
    }
}

# NAT GATEWAY
resource "aws_nat_gateway" "nat_gateway_prob" {
    allocation_id = aws_eip.nat_eip_prob.id
    subnet_id     = aws_subnet.pub_subnet1.id

    tags = {
        "Name" : "Three-Tier Nat Gateway"
        "Terraform" : "true"
    }
}

# INTERNET GATEWAY
resource "aws_internet_gateway" "gw_1" {
    vpc_id = aws_vpc.test-vpc.id

    tags = {
        "Name" : "Three-Tier Internet Gateway"
        "Terraform" : "true"
    }
}

# ROUTE TABLE INTERNET GATEWAY
resource "aws_route_table" "route_table_intgw" {
    vpc_id = aws_vpc.test-vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw_1.id
    }

    tags = {
        "Name" : "Three-Tier Route Table INTGW"
        "Terraform" : "true"
    }
}

# ASSOCIATE PUBLIC SUBNET 1
resource "aws_route_table_association" "route-pub-a-subnet1" {
    subnet_id      = aws_subnet.pub_subnet1.id
    route_table_id = aws_route_table.route_table_intgw.id

    tags = {
        "Name" : "Three-Tier Associate Route Table Pub 1"
        "Terraform" : "true"
    }
}

# ASSOCIATE PUBLIC SUBNET 2
resource "aws_route_table_association" "route-pub-a-subnet2" {
    subnet_id      = aws_subnet.pub_subnet2.id
    route_table_id = aws_route_table.route_table_intgw.id

    tags = {
        "Name" : "Three-Tier Associate Route Table Pub 2"
        "Terraform" : "true"
    }
}

# ROUTE TABLE NAT GATEWAY
resource "aws_route_table" "route_table_natgw" {
    vpc_id = aws_vpc.test-vpc.id
 
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat_gateway_prob.id
    }

    tags = {
        "Name" : "Three-Tier Route Table NATGW"
        "Terraform" : "true"
    }
}

# ASSOCIATE PRIVATE SUBNET 1
resource "aws_route_table_association" "route-priv-a-subnet1" {
    subnet_id      = aws_subnet.priv_subnet1.id
    route_table_id = aws_route_table.route_table_natgw.id

    tags = {
        "Name" : "Three-Tier Associate Route Table Priv 1"
        "Terraform" : "true"
    }
}

# ASSOCIATE PRIVATE SUBNET 2
resource "aws_route_table_association" "route-priv-a-subnet2" {
    subnet_id      = aws_subnet.priv_subnet2.id
    route_table_id = aws_route_table.route_table_natgw.id

    tags = {
        "Name" : "Three-Tier Associate Route Table Priv 2"
        "Terraform" : "true"
    }
}
