
provider "aws" {
  region = "us-east-1"
}

module "network" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.1"

  name = "ecs-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Project = "ecs-lab"
  }
}

resource "aws_ecs_cluster" "this" {
  name = "ecs-lab-cluster"
  tags = {
    Project = "ecs-lab"
  }
}

resource "aws_ecs_task_definition" "node_app" {
  family                   = "node-app-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name  = "node-app"
      image = "gabriel1304/node-app:latest"
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "node_app_service" {
  name            = "node-app-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.node_app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.network.public_subnets
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_tasks.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.node_app_tg.arn
    container_name   = "node-app"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.http]
}

resource "aws_lb" "app_lb" {
  name               = "node-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = module.network.public_subnets
}

resource "aws_lb_target_group" "node_app_tg" {
  name     = "node-app-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = module.network.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.node_app_tg.arn
  }
}
