environment = "testing"
name   = "vpc-app"
vpc_cidr = "10.0.0.0/16"
project = "app"


public_subnets = {
  "a" = { cidr = "10.0.1.0/24", az = "us-west-2a" }
  "b" = { cidr = "10.0.2.0/24", az = "us-west-2b" }
}
private_subnets = {
  "a" = { cidr = "10.0.11.0/24", az = "us-west-2a" }
  "b" = { cidr = "10.0.12.0/24", az = "us-west-2b" }
}
enable_nat_gateway = true

ecs = {
  image        = "nginx:latest"
  cpu          = 512
  memory       = 1024
  host_port    = 80
  desired_count= 1
  max_capacity = 1
  provider_strategy = {
    on_demand = {
      base   = 0
      weight = 0
    }
    spot = {
      base   = 0
      weight = 1
    }
  }
}

rds = {
  availability_zones     = ["us-west-2a","us-west-2b"]
  multi_az               = false
  delete_protection      = false
  port                   = 5432
  engine                 = "aurora-postgresql"
  instance_class         = "db.t4g.medium"
  storage_type           = ""
  engine_version         = "16.2"
  skip_final_snapshot    = true
  parameter_group_family = "aurora-postgresql16"
  backup_retention_period=5
  allowed_ip             = ["10.0.0.0/16"]
}

