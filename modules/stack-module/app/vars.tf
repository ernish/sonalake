variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "ecs" {
  type = object({
    cpu          = number
    memory       = number
    host_port    = number
    desired_count= number
    max_capacity = number
    image        = string
    provider_strategy = object({
      on_demand = object({
        base   = number
        weight = number
      })
      spot = object({
        base   = number
        weight = number
      })
    })
  })
}

variable "project" {
  type = string
}

variable "rds" {
  type = any
}



//TODO more vars because environments can be slighty diffrent (for example vpn or no access to internet)