output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "gateway_id" {
  value = aws_internet_gateway.internetgateway.id
}

output "route_table_id" {
  value = aws_route_table.public_route_table.id
}


output "public_subnet_ids" {
  value = aws_subnet.publicsubnets[*].id
}