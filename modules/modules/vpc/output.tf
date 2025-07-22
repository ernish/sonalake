output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = { for k, s in aws_subnet.public : k => s.id }
}

output "private_subnet_ids" {
  value = { for k, s in aws_subnet.private : k => s.id }
}

output "internet_gateway_id" {
  value = length(aws_internet_gateway.this) > 0 ? aws_internet_gateway.this[0].id : null
}
