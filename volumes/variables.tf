variable "volumes" {
  description = "A map of volume sizes and their corresponding availability zones."
  type        = map(object({
    size              = number
    availability_zone = optional(string)  # Make this field optional
  }))
}


variable "tags" {
  description = "Base tags to apply to the EBS volumes."
  type        = map(string)
}