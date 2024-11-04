resource "aws_dynamodb_table" "this" {
   count = var.create_table ? var.table_count : 0

  name                        = var.name
  billing_mode                = var.billing_mode
  hash_key                    = var.hash_key
  range_key                   = var.range_key
  read_capacity   = var.billing_mode != "PAY_PER_REQUEST" ? var.read_capacity : null
  write_capacity  = var.billing_mode != "PAY_PER_REQUEST" ? var.write_capacity : null
  stream_enabled              = var.stream_enabled
  stream_view_type            = var.stream_view_type
  table_class                 = var.table_class
  deletion_protection_enabled = var.deletion_protection_enabled
  restore_date_time           = var.restore_date_time
  restore_source_name         = var.restore_source_name
  restore_source_table_arn    = var.restore_source_table_arn
  restore_to_latest_time      = var.restore_to_latest_time

  ttl {
    enabled        = var.ttl_enabled
    attribute_name = var.ttl_attribute_name
  }

  point_in_time_recovery {
    enabled = var.point_in_time_recovery_enabled
  }

  dynamic "attribute" {
    for_each = var.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes

    content {
      name               = local_secondary_index.value.name
      range_key          = local_secondary_index.value.range_key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = lookup(local_secondary_index.value, "non_key_attributes", null)
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes

    content {
      name               = global_secondary_index.value.name
      hash_key           = global_secondary_index.value.hash_key
      projection_type    = global_secondary_index.value.projection_type
      range_key          = lookup(global_secondary_index.value, "range_key", null)
      read_capacity      = lookup(global_secondary_index.value, "read_capacity", null)
      write_capacity     = lookup(global_secondary_index.value, "write_capacity", null)
      non_key_attributes = lookup(global_secondary_index.value, "non_key_attributes", null)

      dynamic "on_demand_throughput" {
        for_each = try([global_secondary_index.value.on_demand_throughput], [])

        content {
          max_read_request_units  = try(on_demand_throughput.value.max_read_request_units, null)
          max_write_request_units = try(on_demand_throughput.value.max_write_request_units, null)
        }
      }
    }
  }

  dynamic "replica" {
    for_each = var.replica_regions

    content {
      region_name            = replica.value.region_name
      kms_key_arn            = lookup(replica.value, "kms_key_arn", null)
      propagate_tags         = lookup(replica.value, "propagate_tags", null)
      point_in_time_recovery = lookup(replica.value, "point_in_time_recovery", null)
    }
  }

  server_side_encryption {
    enabled     = var.server_side_encryption_enabled
    kms_key_arn = var.server_side_encryption_kms_key_arn
  }

  dynamic "import_table" {
    for_each = length(var.import_table) > 0 ? [var.import_table] : []

    content {
      input_format           = import_table.value.input_format
      input_compression_type = try(import_table.value.input_compression_type, null)

      dynamic "input_format_options" {
        for_each = try([import_table.value.input_format_options], [])

        content {

          dynamic "csv" {
            for_each = try([input_format_options.value.csv], [])

            content {
              delimiter   = try(csv.value.delimiter, null)
              header_list = try(csv.value.header_list, null)
            }
          }
        }
      }

      s3_bucket_source {
        bucket       = import_table.value.bucket
        bucket_owner = try(import_table.value.bucket_owner, null)
        key_prefix   = try(import_table.value.key_prefix, null)
      }
    }
  }

  dynamic "on_demand_throughput" {
    for_each = length(var.on_demand_throughput) > 0 ? [var.on_demand_throughput] : []

    content {
      max_read_request_units  = try(on_demand_throughput.value.max_read_request_units, null)
      max_write_request_units = try(on_demand_throughput.value.max_write_request_units, null)
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = format("%s", var.name)
    },
  )

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }
}


  