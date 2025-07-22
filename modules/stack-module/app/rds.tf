module "rds" {
  source = "../../modules/rds-aurora"

  rds                    = var.rds
  environment            = var.environment
  private_subnets        = var.private_subnets
  vpc_id                 = var.vpc_id

}