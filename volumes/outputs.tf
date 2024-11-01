output "volume_ids" {
  value = [for volume in aws_ebs_volume.this : volume.id]  # Using a for expression
}
