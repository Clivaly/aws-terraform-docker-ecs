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