################################################################################
# File System
################################################################################

resource "aws_efs_file_system" "this" {
  count = var.create ? 1 : 0

  availability_zone_name          = var.availability_zone_name
  creation_token                  = var.creation_token
  performance_mode                = var.performance_mode
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_arn
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode

  dynamic "lifecycle_policy" {
    for_each = [for k, v in var.lifecycle_policy : { (k) = v }]

    content {
      transition_to_ia                    = try(lifecycle_policy.value.transition_to_ia, null)
      transition_to_archive               = try(lifecycle_policy.value.transition_to_archive, null)
      transition_to_primary_storage_class = try(lifecycle_policy.value.transition_to_primary_storage_class, null)
    }
  }

  tags = merge(
    var.tags,
    { Name = var.name },
  )
}


################################################################################
# Mount Target(s)
################################################################################

resource "aws_efs_mount_target" "this" {
  for_each = { for k, v in var.mount_targets : k => v if var.create }

  file_system_id  = aws_efs_file_system.this[0].id
  ip_address      = try(each.value.ip_address, null)
  security_groups = var.create_security_group ? concat([aws_security_group.this[0].id], try(each.value.security_groups, [])) : try(each.value.security_groups, null)
  subnet_id       = each.value.subnet_id
}

################################################################################
# Security Group
################################################################################

locals {
  security_group_name = try(coalesce(var.security_group_name, var.name), "")

  create_security_group = var.create && var.create_security_group && length(var.mount_targets) > 0
}

resource "aws_security_group" "this" {
  count = local.create_security_group ? 1 : 0

  name        = var.security_group_use_name_prefix ? null : local.security_group_name
  name_prefix = var.security_group_use_name_prefix ? "${local.security_group_name}-" : null
  description = var.security_group_description

  revoke_rules_on_delete = true
  vpc_id                 = var.security_group_vpc_id

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "this" {
  for_each = { for k, v in var.security_group_rules : k => v if local.create_security_group }

  security_group_id = aws_security_group.this[0].id

  description              = try(each.value.description, null)
  type                     = try(each.value.type, "ingress")
  from_port                = try(each.value.from_port, 2049)
  to_port                  = try(each.value.to_port, 2049)
  protocol                 = try(each.value.protocol, "tcp")
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = try(each.value.self, null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)

  lifecycle {
    create_before_destroy = true
  }
}

################################################################################
# Access Point(s)
################################################################################

# Access point(s)
access_points = {
  posix_example = {
    name = "posix-example"
    posix_user = {
      gid            = 1001
      uid            = 1001
      secondary_gids = [1002]
    }

    root_directory = {
      posix_user = {
        gid            = 1001
        uid            = 1001
        secondary_gids = [1002]
      }

      path = "/example"

      creation_info = {
        owner_gid   = 1001
        owner_uid   = 1001
        permissions = "755"
      }
    }

    tags = {
      Additionl = "yes"
    }
  }
}

