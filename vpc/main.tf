resource "aws_vpc" "this" {
  count = var.create_vpc ? var.vpc_count : 0

  # IPv4 configuration
  cidr_block          = var.use_ipam_pool ? null : element(var.cidr_blocks, count.index)
  ipv4_ipam_pool_id   = var.use_ipam_pool ? var.ipv4_ipam_pool_id : null
  ipv4_netmask_length = var.use_ipam_pool ? var.ipv4_netmask_length : null

  # IPv6 configuration
  assign_generated_ipv6_cidr_block = var.enable_ipv6 && !var.use_ipam_pool ? true : null
  ipv6_cidr_block                   = var.enable_ipv6 && !var.use_ipam_pool ? var.ipv6_cidr : null
  ipv6_ipam_pool_id                 = var.enable_ipv6 && var.use_ipam_pool ? var.ipv6_ipam_pool_id : null
  ipv6_netmask_length               = var.enable_ipv6 && var.use_ipam_pool ? var.ipv6_netmask_length : null
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = var.vpc_count > 0 ? var.vpc_count : 0  # Adjust based on the count
  vpc_id = aws_vpc.this[count.index].id
  cidr_block = var.secondary_cidr_blocks[count.index]
}


resource "aws_subnet" "public" {
  count                   = var.public_subnet_count * var.vpc_count
  vpc_id                  = aws_vpc.this[floor(count.index / var.public_subnet_count)].id
  cidr_block              = element(var.public_subnet_cidrs, count.index % var.public_subnet_count)
  availability_zone       = element(var.availability_zones, count.index % var.public_subnet_count)

  map_public_ip_on_launch = true

  tags = merge(
    { "Name" = "${var.name}-public-${count.index}" },
    var.tags
  )
}

resource "aws_subnet" "private" {
  count             = var.private_subnet_count * var.vpc_count
  vpc_id            = aws_vpc.this[floor(count.index / var.private_subnet_count)].id
  cidr_block        = element(var.private_subnet_cidrs, count.index % var.private_subnet_count)
  availability_zone = element(var.availability_zones, count.index % var.private_subnet_count)

  tags = merge(
    { "Name" = "${var.name}-private-${count.index}" },
    var.tags
  )
}

