resource "aws_launch_template" "launch-temp" {
    name = "lanch-temp"
    image_id = var.ami
    instance_type = "t2.medium"
    key_name = var.key-name
    vpc_security_group_ids = [var.asg-sg]
    user_data = base64encode(templatefile("./module/prod-asg/docker-script.sh",{
        nexus-ip = var.nexus-prd
        newrelic-license-key = var.nr-key-prd
        newrelic-account-id =var.nr-acc-id-prd 
        newrelic-region = var.nr-region-prd

    }))
    tags ={
        Name = "launch-temp"
    }
}
# Create an Auto Scaling Group (ASG) for the stage environment
resource "aws_autoscaling_group" "asg-prod" {
  name                      = var.asg-prod
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  vpc_zone_identifier       = var.vpc-zone-id-prod
  target_group_arns         = [var.tg-arn]
  launch_template {
    id = aws_launch_template.launch-temp.id
  }
  tag {
    key                 = "Name"
    value               = var.asg-prod
    propagate_at_launch = true
  }
}

# Create autoscaling policy for dynamic scaling based on CPU utilization.
resource "aws_autoscaling_policy" "asp-prod" {
  name                   = "prod-asg-policy"
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.asg-prod.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}