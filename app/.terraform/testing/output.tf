output "alb_dns" {
  value = "${module.ecs_app.alb_url}:8080" //TODO hardcoded 8080
}