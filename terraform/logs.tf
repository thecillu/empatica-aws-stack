# logs.tf

# Set up CloudWatch group and log stream and retain logs for 30 days
resource "aws_cloudwatch_log_group" "empatica_log_group" {
  name              = "/ecs/empatica-app"
  retention_in_days = 30

  tags = {
    Name = "empatica-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "empatica_log_stream" {
  name           = "empatica-log-stream"
  log_group_name = aws_cloudwatch_log_group.empatica_log_group.name
}

