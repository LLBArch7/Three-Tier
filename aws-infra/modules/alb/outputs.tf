output "alb_dns_name" {
  value       = concat(aws_lb.this.*.dns_name, [""])[0]
}