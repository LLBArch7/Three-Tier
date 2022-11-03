module "CreateVPC" {
    source = "./modules/vpc"
    public_subnets1 = var.aws_public_subnets1
    public_subnets2 = var.aws_public_subnets2
    main_vpc_cidr = var.aws_main_vpc_cidr
    availability_zones_data = data.aws_availability_zones.available
}

module "CreateSG" {
    source = "./modules/sg"
    vpc_id = module.CreateVPC.vpc_id
}

module "CreateEC2" {
    source = "./modules/ec2"
    ami = var.aws_ami
    instance_type = var.aws_instance_type
    public_subnets1_id = module.CreateVPC.public_subnets1_id
    key = var.aws_key
    vpc_security_group_id_1 = module.CreateSG.vpc_security_group_id_1
}

module "CreateALB" {
    source = "./modules/ec2"
    vpc_id = module.CreateVPC.vpc_id
    public_subnets1_id = module.CreateVPC.public_subnets1_id
    jenkins_plus_ssh = module.CreateSG.jenkins_plus_ssh
    aws_main_vpc_cidr = var.aws_main_vpc_cidr
    ec2_id = module.CreateEC2.ec2_id
}