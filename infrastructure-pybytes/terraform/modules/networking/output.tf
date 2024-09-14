output "aws_vpc_route_table_id" {
  value = aws_route_table.this.id
}

output "aws_vpc_subnet_id" {
  value = aws_subnet.public.id
}

output "aws_vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnet_1" {
  value = aws_subnet.private_subnet_1.id
}

output "private_subnet_2" {
  value = aws_subnet.private_subnet_2.id
}
