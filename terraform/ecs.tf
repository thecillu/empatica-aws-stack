# ecs.tf

resource "aws_ecs_cluster" "empatica_ecs_cluster" {
  name = "empatica-cluster"
}

data "aws_ecr_repository" "repo" {
  name = "empatica-registry"
}

data "template_file" "empatica_app" {
  template = file("./templates/ecs/empatica_app.json.tpl")

  vars = {
    app_image      = "${data.aws_ecr_repository.repo.repository_url}:${var.image_version}"
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws_region     = var.aws_region
    database_name   = var.database_name
    database_username    = var.database_username
    database_password    = var.database_password
    database_endpoint    = aws_db_instance.empatica_database.endpoint
  }
}

resource "aws_ecs_task_definition" "empatica_td" {
  family                   = "empatica-app-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.empatica_app.rendered
}

resource "aws_ecs_service" "empatica_ecs_service" {
  name            = "empatica-ecs-service"
  cluster         = aws_ecs_cluster.empatica_ecs_cluster.id
  task_definition = aws_ecs_task_definition.empatica_td.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.empatica_tg.id
    container_name   = "empatica-app"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.front_end, aws_iam_role_policy_attachment.ecs_task_execution_role]
}

