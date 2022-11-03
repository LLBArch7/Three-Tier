output "vpc_security_group_id_1" {
    value = aws_security_group.web_ssh.id
}

output "vpc_alb_security_group_id" {
    value = aws_security_group.web_ssh.id
}