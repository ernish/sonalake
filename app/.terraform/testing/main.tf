module "vpc" {
  source   = "../../../modules/modules/vpc"
  name     = var.name
  vpc_cidr = var.vpc_cidr

  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  enable_nat_gateway = var.enable_nat_gateway

}


module "ecs_app" {
  source = "../../../modules/stack-module/app"

  project         =var.project

  vpc_id          = module.vpc.vpc_id
  public_subnets  = values(module.vpc.public_subnet_ids)
  private_subnets = values(module.vpc.private_subnet_ids)
  region          = var.region
  environment     = var.environment

  ecs = var.ecs
  rds = var.rds

}