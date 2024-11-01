variable "create_vpc" {
  description = "Whether to create the VPC"
  type        = bool
  default     = true
}

variable "vpc_count" {
  description = "Number of VPCs to create"
  type        = number
  default     = 1
}

variable "cidr_blocks" {
  description = "List of CIDR blocks for the VPCs"
  type        = list(string)
}

variable "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks for the VPCs"
  type        = list(string)
  default     = []
}

variable "public_subnet_count" {
  description = "Number of public subnets to create"
  type        = number
}

variable "private_subnet_count" {
  description = "Number of private subnets to create"
  type        = number
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "name" {
  description = "Base name for resources"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "use_ipam_pool" {
  description = "Whether to use IPAM pool"
  type        = bool
  default     = false
}

variable "ipv4_ipam_pool_id" {
  description = "IPAM pool ID for IPv4"
  type        = string
  default     = ""
}

variable "ipv4_netmask_length" {
  description = "IPv4 netmask length"
  type        = number
  default     = 16
}

variable "enable_ipv6" {
  description = "Whether to enable IPv6"
  type        = bool
  default     = false
}

variable "ipv6_cidr" {
  description = "IPv6 CIDR block"
  type        = string
  default     = ""
}

variable "ipv6_ipam_pool_id" {
  description = "IPAM pool ID for IPv6"
  type        = string
  default     = ""
}

variable "ipv6_netmask_length" {
  description = "IPv6 netmask length"
  type        = number
  default     = 64
}
