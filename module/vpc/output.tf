output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "public-subnet1" {
  value = aws_subnet.public-subnet[0] .id
}
output "public-subnet2" {
    value = aws_subnet.public-subnet [1] .id
  
}

output "public-subnet3" {
    value = aws_subnet.public-subnet[2].id
  
}
output "private-subnet1" {
    value = aws_subnet.private-subnet [0] .id
  
}
output "private-subnet2" {
    value = aws_subnet.private-subnet [1] .id

}

output "private-subnet3" {
    value = aws_subnet.private-subnet [2] .id
  
}
