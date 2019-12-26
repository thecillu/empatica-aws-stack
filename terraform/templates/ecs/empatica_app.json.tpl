[
  {
    "name": "empatica-app",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "environment": [{
      "name": "DB_ENDPOINT",
      "value": "${database_endpoint}"
    },
    {
      "name": "DB_NAME",
      "value": "${database_name}"
    },
    {
      "name": "DB_USERNAME",
      "value": "${database_username}"
    },
    {
      "name": "DB_PASSWORD",
      "value": "${database_password}"
    }],
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/empatica-app",
          "awslogs-region": "${aws_region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ]
  }
]
