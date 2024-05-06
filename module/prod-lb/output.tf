output "prod-lb-dns_name" {
    value = aws_lb.prod-lb.dns_name
}

output "prod-lb-arn" {
    value = aws_lb.prod-lb.arn
  
}

output "prod-lb-zone_id" {
    value = aws_lb.prod-lb.zone_id
  
}
output "prod-tg-arn" {
    value = aws_lb_target_group.prod-tg.arn
  
}