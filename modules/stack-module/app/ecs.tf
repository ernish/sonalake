resource "aws_cloudwatch_log_group" "app" {
  name = "/${var.environment}/app"
}

resource "aws_ecs_task_definition" "app" {
  family                = "${terraform.workspace}-app"
  execution_role_arn    = module.iam_execution_role.out-iam-role.arn
  cpu                   = var.ecs.cpu
  task_role_arn         = module.iam_execution_role.out-iam-role.arn
  memory                = var.ecs.memory
  network_mode          = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  runtime_platform {
    operating_system_family = "LINUX"
  }
  container_definitions = jsonencode([
    {
      logConfiguration: {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/${var.environment}/app",
          "awslogs-region": var.region,
          "awslogs-stream-prefix": "ecs"
        }
      },
      cpu: var.ecs.cpu,
      environment: [
        { name: "TEST", value: "TEST" }
      ],
      memory: var.ecs.memory,
      portMappings: [
        {
          hostPort: var.ecs.host_port,
          protocol: "tcp",
          containerPort: var.ecs.host_port
        }
      ],
      volumesFrom: [],
      image: var.ecs.image,
      essential: true,
      name: "${var.environment}-app"
    }

  ])

}

data "aws_ecs_task_definition" "app" {
  task_definition = aws_ecs_task_definition.app.family
}

resource "aws_ecs_service" "app" {
  name            = "${var.environment}-app"
  platform_version= "LATEST"
  cluster         = aws_ecs_cluster.app.name
  desired_count   = var.ecs.desired_count
  task_definition = "${aws_ecs_task_definition.app.family}:${max("${aws_ecs_task_definition.app.revision}", "${data.aws_ecs_task_definition.app.revision}")}"
  enable_execute_command = true


  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "${var.environment}-app"
    container_port   = var.ecs.host_port
  }


  capacity_provider_strategy {
    base              = var.ecs.provider_strategy.on_demand.base
    capacity_provider = "FARGATE"
    weight            = var.ecs.provider_strategy.on_demand.weight
  }
  capacity_provider_strategy {
    base              = var.ecs.provider_strategy.spot.base
    capacity_provider = "FARGATE_SPOT"
    weight            = var.ecs.provider_strategy.spot.weight
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }
  network_configuration {
    subnets          = var.private_subnets
    assign_public_ip = false
    security_groups  = [module.app_ecs_security_group.sg_id]
  }

}


module "app_ecs_security_group" {
  source = "../../modules/security-group"

  description   = "APP Security Group ECS"
  name          = "${var.environment}-sg-ecs"
  vpc_id        = var.vpc_id
  allowed_ip    = ["0.0.0.0/0"]
  allowed_ports = [var.ecs.host_port]
}



