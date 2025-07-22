resource "aws_rds_cluster" "aurora" {
  cluster_identifier     = "${var.environment}-${var.project}"
  availability_zones     = var.rds.availability_zones
  database_name          = var.project
  master_username        = var.project
  port                   = var.rds.port
  master_password        = random_password.aurora.result
  engine                 = var.rds.engine
  db_subnet_group_name   = aws_db_subnet_group.aurora.name
  vpc_security_group_ids = [module.aurora_rds_security_group.sg_id]
  skip_final_snapshot    = var.rds.skip_final_snapshot
  storage_encrypted      = true
  deletion_protection    = var.rds.delete_protection
  engine_version         = var.rds.engine_version
  backup_retention_period= var.rds.backup_retention_period
  storage_type           = var.rds.storage_type
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora.name
}

resource "aws_rds_cluster_instance" "aurora1" {
  identifier                = "${var.environment}-${var.project}"
  cluster_identifier        = aws_rds_cluster.aurora.id
  instance_class            = var.rds.instance_class
  engine                    = aws_rds_cluster.aurora.engine
  engine_version            = aws_rds_cluster.aurora.engine_version
  db_parameter_group_name   = aws_db_parameter_group.aurora.name
  auto_minor_version_upgrade=false
}

resource "aws_rds_cluster_instance" "aurora2" {
  count = var.rds.multi_az == false ? 0 : 1

  identifier                = "${var.environment}-${var.project}-2"
  cluster_identifier        = aws_rds_cluster.aurora.id
  instance_class            = var.rds.instance_class
  engine                    = aws_rds_cluster.aurora.engine
  engine_version            = aws_rds_cluster.aurora.engine_version
  db_parameter_group_name   = aws_db_parameter_group.aurora.name
  auto_minor_version_upgrade=false

  depends_on = [aws_rds_cluster_instance.aurora1]
}

resource "aws_db_subnet_group" "aurora" {
  name       = "${var.environment}-${var.project}"
  subnet_ids = var.private_subnets
}

module "aurora_rds_security_group" {
  source = "../security-group"

  description   = "Security Group ${var.project} Aurora RDS"
  name          = "${var.environment}-rds"
  vpc_id        = var.vpc_id
  allowed_ip    = var.rds.allowed_ip
  allowed_ports = [5432]
}

resource "aws_db_parameter_group" "aurora" {
  name        = "${var.environment}-${var.project}"
  family      = var.rds.parameter_group_family
  description = "${var.environment} ${var.project} Instance Group"
}

resource "aws_rds_cluster_parameter_group" "aurora" {
  name        = "${var.environment}-${var.project}"
  family      = var.rds.parameter_group_family
  description = "${var.environment} ${var.project} Cluster Group"
}