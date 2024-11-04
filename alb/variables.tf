variable "create" {
  type    = bool
  default = true
}

variable "access_logs" {
  type = list(object({
    bucket  = string
    enabled = bool
    prefix  = optional(string)
  }))
  default = []
}

variable "subnets" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}



variable "load_balancer_name" {
  type = string
}

variable "target_group_count" {
  type    = number
  default = 1
}

variable "target_group_port" {
  type    = number
  default = 80
}

variable "target_group_protocol" {
  type    = string
  default = "HTTP"
}

variable "vpc_id" {
  type = string
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "health_check_interval" {
  type    = number
  default = 30
}

variable "health_check_timeout" {
  type    = number
  default = 5
}

variable "health_check_healthy_threshold" {
  type    = number
  default = 2
}

variable "health_check_unhealthy_threshold" {
  type    = number
  default = 2
}



variable "ec2_instance_ids" {
  type = list(string)
}


variable "load_balancer_arn" {
  type = string
}

variable "listeners" {
  type = map(object({
    port            = optional(number, 80)
    protocol        = optional(string, "HTTP")
    default_actions = list(object({
      type            = string
      target_groups   = list(object({
        target_group_key = string
        weight           = optional(number)
      }))
      order           = optional(number, 1)
    }))
  }))
}

