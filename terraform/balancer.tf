# creates a target group on port 80 with HTTP protocol
resource "aws_lb_target_group" "terra_target" {
    name = lookup(var.terra_var, "terraapp")
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.terra-vpc.id

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

# creates a internet facing application load balancer. 
resource "aws_lb" "terra_lb" {
  name = lookup(var.terra_var, "lb")
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.terra_sec.id]
  subnets = [for terra_sub in aws_subnet.terra-subnet : terra_sub.id]

  enable_deletion_protection = false
  
  tags = {
    Environment = "terra_target"
  }
}

# creates a listener on port 80
resource "aws_lb_listener" "terra_listener" {
    load_balancer_arn = aws_lb.terra_lb.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.terra_target.arn
    }
}

# attaches the created ec2 resources to the load balancer
resource "aws_lb_target_group_attachment" "terra_attachment" {
  target_group_arn = aws_lb_target_group.terra_target.arn
  target_id        = aws_instance.terra_ec2[count.index].id
  port             = 80

  count = 3
}