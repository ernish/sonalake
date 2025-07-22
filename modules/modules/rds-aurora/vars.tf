variable "region" {
  type = string
  default = "us-east-1"
}
variable "project" {
  type = string
  default = "aurora"
}

variable "rds" {
  type = any
}

variable "vpc_id" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "environment" {
  type = string
}


