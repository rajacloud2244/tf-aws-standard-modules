variable "create" {
  description = "Whether to create the ALB"
  type        = bool
  default     = true
}

variable "access_logs" {
  description = "Access logs configuration"
  type        = list(object({
    enabled = bool
    bucket  = string
    prefix  = string
  }))
  default     = []
}

variable "subnets" {
  description = "Subnets for the ALB"
  type        = list(string)
}

variable "load_balancer_name" {
  description = "Name of the load balancer"
  type        = string
}

variable "target_group_count" {
  description = "Number of target groups"
  type        = number
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB is deployed"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group (optional)"
  type        = string
  default     = null
}

# Other variables as needed...
