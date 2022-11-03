output "vpc_security_group_id_1" {
    value = aws_security_group.web_ssh.id
}

output "jenkins_plus_ssh" {
    value = aws_security_group.jenkins_plus_ssh.id
}