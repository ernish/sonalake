resource "random_password" "aurora" {
  length = 25
  override_special = "!#$%&()*+,-.:;<=>?[]^_`{|}~"
}

resource "aws_secretsmanager_secret" "rds_aurora" {
  name                    = "rds-${var.environment}-${var.project}"
  recovery_window_in_days = 0
  description             = "Credentials to RDS ${var.project} instnace"
}

resource "aws_secretsmanager_secret_version" "rds_aurora" {
  secret_id     = aws_secretsmanager_secret.rds_aurora.id
  secret_string =  "{\"engine\" :\"${aws_rds_cluster.aurora.engine}\",\"dbname\" :\"${var.project}\",\"port\" :${aws_rds_cluster.aurora.port},\"username\" :\"${aws_rds_cluster.aurora.master_username}\",\"password\" :\"${aws_rds_cluster.aurora.master_password}\",\"host\" :\"${aws_rds_cluster_instance.aurora1.endpoint}\"}"
}

