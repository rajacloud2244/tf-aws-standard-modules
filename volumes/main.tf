data "aws_availability_zones" "available" {}

resource "aws_ebs_volume" "this" {
  for_each = var.volumes

  availability_zone = coalesce(each.value.availability_zone, data.aws_availability_zones.available.names[0])  # Fallback to first AZ if null
  size              = each.value.size

  tags = merge(
    var.tags,
    {
      Name = "${var.tags.Name}-${each.key}"  # Unique name for each volume
    }
  )
}


