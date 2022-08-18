resource "aws_security_group" "alb" {
  name        = "alb_ecs"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "tcp_alb_in" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "tcp_alb_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"   # allowed all 
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}