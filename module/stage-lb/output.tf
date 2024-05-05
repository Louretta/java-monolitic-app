output "stage-lb-dns_name" {
    value = aws_lb.stage-lb.dns_name

}

output "stage_lb-arn" {
    value= aws_lb.stage-lb.arn
  
}

output "stage-lb-zone_id" {
    value = aws_lb.stage-lb.zone_id
  
}

output "stage-tg-arn" {
    value = aws_lb_target_group.stage-tg.arn
  
}