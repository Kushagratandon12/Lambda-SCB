resource "aws_launch_template" "kushagra-template" {
    name_prefix = "kushagra-template"
    image_id = "ami-08df646e18b182346"
    instance_type = "t3a.nano"
    user_data = filebase64("app-launch.sh")
}

resource "aws_autoscaling_group" "kushagra-autoscale" {
    availability_zones        = ["ap-south-1"]
    name                      = "kushagra-autoscale"
    max_size                  = 3
    min_size                  = 1
    health_check_grace_period = 180
    health_check_type         = "ELB"
    force_delete              = true
    termination_policies      = ["OldestInstance"]
    launch_template {
        id      = aws_launch_template.kushagra-template.id
        version = "$Latest"
    }
    target_group_arns = [ aws_lb_target_group.kushagra.arn ]
}

resource "aws_autoscaling_policy" "test" {
  name                   = "test"
  autoscaling_group_name = aws_autoscaling_group.kushagra-autoscale.name
  policy_type            = "PredictiveScaling"
  predictive_scaling_configuration {
    metric_specification {
      target_value = 10
      predefined_load_metric_specification {
        predefined_metric_type = "ASGTotalCPUUtilization"
        resource_label         = "test"
      }
      customized_scaling_metric_specification {
        metric_data_queries {
          id = "scaling"
          metric_stat {
            metric {
              metric_name = "CPUUtilization"
              namespace   = "AWS/EC2"
              dimensions {
                name  = "AutoScalingGroupName"
                value = "test"
              }
            }
            stat = "Average"
          }
        }
      }
    }
  }
}

data "aws_vpc" "main"{
    id="vpc-07ba180c1c26e2f4c"
}

data "aws_subnet_ids" "main" {
  vpc_id = data.aws_vpc.main.id
}

data "aws_subnet" "kushagra-vpc" {
    vpc_id = data.aws_subnet_ids.main.ids
    id = each.value
}

resource "aws_lb" "kushagra-loadbalancer"{
    name = "kushagra-loadbalancer"
    internal = false
    load_balancer_type = "network"
    subnets = [aws_subnet.kushagra-vpc-pb-1a.aws_subnet.kushagra-vpc-pb-1a.id]
}

resource "aws_lb_listener" "kushagra-loadbalancer" {
    load_balancer_arn = aws_lb.kushagra.arn
    port = 80
    provider = "TCP"
    default_action {
        type="forward"
        target_group_arn = aws_lb_target_group.kushagra.arn
    }
}

resource "aws_lb_target_group" "kushagra" {
  name     = "kushagra"
  port     = 80
  protocol = "TCP"
  vpc_id   = data.aws_vpc.main.id
}