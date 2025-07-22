variable "environment" {
  type = string
}


variable "region" {
  type = string
  default = "us-west-2"
}

variable "ecs" {
  type = any
}

variable "rds" {
  type = any
}

variable "project" {
  type = string
}

variable "name" {
  type = string
}

variable "vpc_cidr" {
  type = string
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
