resource "aws_launch_template" "stage-temp" {
    name = "stage-temp"
    image_id = var.ami
    instance_type = "t3.medium"
    key_name = var.key-name
    vpc_security_group_ids = [var.asg-sg]
    user_data = base64encode(templatefile("./module/stage-asg/docker-script.sh",{
        nexus-ip = var.nexus-stage
        newrelic-license-key = var.nr-key-stage
        newrelic-account-id = var.nr-acc-id-stage
        newrelic-region = var.nr-region-stage
    }))
    tags ={
        Name = "stage-temp"
    }
}
# Create an Auto Scaling Group (ASG) for the stage environment
resource "aws_autoscaling_group" "asg-stg" {
  name                      = var.asg-stage
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = var.vpc-zone-id-stage
  target_group_arns         = [var.tg-arn]
  launch_template {
    id = aws_launch_template.stage-temp.id
  }
  tag {
    key                 = "Name"
    value               = var.asg-stage
    propagate_at_launch = true
  }
}

# Create autoscaling policy for dynamic scaling based on CPU utilization.
resource "aws_autoscaling_policy" "asp-stg" {
  name                   = "stg-asg-policy"
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.asg-stg.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}