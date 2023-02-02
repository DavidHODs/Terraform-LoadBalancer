resource "aws_lb_target_group" "terra_target" {
    name = lookup(var.terra_var, "terraapp")
    # instances = [for terra_instance in aws_instance.terra_ec2 : terra_instance.id]
    port = 80
    protocol = "HTTP"
    vpc_id = lookup(var.terra_var, "vpc")

    health_check {
      enabled = true
      healthy_threshold = 3
      interval = 10
      matcher = 200
      path = "/"
      port = "traffic-port"
      protocol = "HTTP"
      timeout = 3
      unhealthy_threshold = 2
    }
}


resource "aws_lb" "terra_lb" {
  name = lookup(var.terra_var, "lb")
#   availability_zones = ["us-west-1a", "us-west-1b"]
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.terra_sec.id]
  subnets = [for terra_sub in aws_subnet.subnet : terra_sub.id]

  enable_deletion_protection = false
  
  tags = {
    Environment = "terra_target"
  }
}


resource "aws_lb_listener" "terra_listener" {
    load_balancer_arn = aws_lb.terra_lb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.terra_target.arn
    }
}