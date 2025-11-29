# Data source to reference existing launch template
data "aws_launch_template" "example" {
  name = "Project-LT"
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  name                = "capstone-app-asg"
  vpc_zone_identifier = var.private_subnet_ids
  target_group_arns   = [var.target_group_arn]
  health_check_type   = "ELB"
  health_check_grace_period = 300
  
  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  launch_template {
    id      = data.aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "capstone-app-server"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Target Tracking Scaling Policy - scales based on CPU utilization
resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "cpu-target-tracking-policy"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0  # Target 50% CPU utilization (adjust as needed)
  }
}