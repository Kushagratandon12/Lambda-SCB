resource "aws_launch_template" "kushagra-template" {
    name_prefix = "kushagra-template"
    image_id = "ami-08df646e18b182346"
    instance_type = "t3a.nano"
    user_data = filebase64("app-launch.sh")
}

resource "aws_autoscaling_group" "kushagra-autoscale" {
    availability_zones        = ["ap-south-1a"]
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
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.kushagra-autoscale.name
  scaling_adjustment     = 2
  cooldown               = 180
}

data "aws_vpc" "main"{
    id="vpc-07ba180c1c26e2f4c"
}

data "aws_subnet_ids" "test" {
  vpc_id = data.aws_vpc.main.id
  tags = {  
    Name = "kushagra-vpc-pb-1a"
  }
}

data "aws_subnet" "test" {
    for_each = data.aws_subnet_ids.test.ids
    id = each.value
}

resource "aws_lb" "kushagra-loadbalancer"{
    name = "kushagra-loadbalancer"
    internal = false
    load_balancer_type = "network"
      subnets            = [for subnet in data.aws_subnet.test : subnet.id]
}

resource "aws_lb_listener" "kushagra-loadbalancer" {
    load_balancer_arn = aws_lb.kushagra-loadbalancer.arn
    port = 80
    protocol = "TCP"
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