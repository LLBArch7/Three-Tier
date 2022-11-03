#EC2 SEC GROUP
resource "aws_security_group" "web_ssh" {
    name        = "ssh-access"
    description = "open ssh traffic"
    vpc_id      = var.vpc_id

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        "Name" : "Web-SSH"
        "Terraform" : "true"
    }
}

#ALB SEC GROUP
resource "aws_security_group" "jenkins_plus_ssh" {
    name        = "Jenkins-access and SSH"
    description = "open port 8080 and 22"
    vpc_id      = var.vpc_id

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        "Name" : "Jenkins Port and SSH"
        "Terraform" : "true"
    }
}