# auto_scaling.tf

resource "aws_appautoscaling_target" "ecs_tg" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.empatica_ecs_cluster.name}/${aws_ecs_service.empatica_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 2
  max_capacity       = 4
}

# Automatically scale capacity up by one
resource "aws_appautoscaling_policy" "up" {
  name               = "empatica_scale_up"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.empatica_ecs_cluster.name}/${aws_ecs_service.empatica_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 1
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.ecs_tg]
}

# Automatically scale capacity down by one
resource "aws_appautoscaling_policy" "down" {
  name               = "empatica_scale_down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.empatica_ecs_cluster.name}/${aws_ecs_service.empatica_ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 1
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.ecs_tg]
}

# CloudWatch alarm that triggers the autoscaling up policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_high" {
  alarm_name          = "empatica_cpu_utilization_high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    ClusterName = aws_ecs_cluster.empatica_ecs_cluster.name
    ServiceName = aws_ecs_service.empatica_ecs_service.name
  }

  alarm_actions = [aws_appautoscaling_policy.up.arn]
}

# CloudWatch alarm that triggers the autoscaling down policy
resource "aws_cloudwatch_metric_alarm" "service_cpu_low" {
  alarm_name          = "empatica_cpu_utilization_low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              =  "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    ClusterName = aws_ecs_cluster.empatica_ecs_cluster.name
    ServiceName = aws_ecs_service.empatica_ecs_service.name
  }

  alarm_actions = [aws_appautoscaling_policy.down.arn]
}

