resource "aws_ecs_cluster" "app" {
  name = "${var.environment}-app"
}