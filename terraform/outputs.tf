# outputs.tf

output "alb_hostname" {
  value = aws_alb.empatica_lb.dns_name
}

