variable "instance_ids" {
  type        = list(string)
  description = "List of EC2 instance IDs"
}

variable "volume_ids" {
  type        = list(string)
  description = "List of EBS volume IDs"
}
