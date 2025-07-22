variable "name" {
  type        = string
}

variable "vpc_cidr" {
  type        = string
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {}
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  default = {}
}

variable "enable_nat_gateway" {
  type        = bool
  default     = false
}
