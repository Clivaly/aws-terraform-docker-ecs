module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  name = var.environment
  container_insights = true
  capacity_providers = ["FARGATE"]
  default_capacity_provider_strategy = [
    {
      capacity_provider = "FARGATE"
    }
  ]
}

resource "aws_ecs_task_definition" "Django-API" {
  family                   = "Django-API"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.office.arn
  container_definitions    = jsonencode(
        [
            {
                "name"= "production"
                "image"= "454555515218.dkr.ecr.us-west-2.amazonaws.com/prod:v1"
                "cpu"= 256
                "memory"= 512
                "essential"= true
                "portMappings": [
                    {
                        "containerPort"= 8000
                        "hostPort"= 8000
                    }
                ],
            }
        ]
    )
}

resource "aws_ecs_service" "Django-API" {
  name            = "Django-API"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.Django-API.arn
  desired_count   = 3

  load_balancer {
    target_group_arn = aws_lb_target_group.target_ecs.arn
    container_name   = "production"
    container_port   = 8000
  }

  network_configuration {
    subnets = module.vpc.private_subnets
    security_groups = [aws_security_group.alb_private.id]
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight = 1   # 100/100
  }
}