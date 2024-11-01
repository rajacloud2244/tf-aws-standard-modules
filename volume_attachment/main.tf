resource "aws_volume_attachment" "this" {
  for_each = { for idx in range(length(var.instance_ids)) : idx => {
    instance_id = var.instance_ids[idx]
    volume_id   = var.volume_ids[idx]
  }}

  device_name = "/dev/sdh"  # Change this as needed
  volume_id   = each.value.volume_id  # Accessing volume ID from the pair
  instance_id = each.value.instance_id  # Accessing instance ID from the pair
}
