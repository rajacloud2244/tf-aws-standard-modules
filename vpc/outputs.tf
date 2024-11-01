output "created_vpcs" {
  value = aws_vpc.this[*].id  # This will give you a list of all VPC IDs
}
