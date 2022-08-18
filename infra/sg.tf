# SG public
resource "aws_security_group" "alb_public" {
  name        = "public_alb_ecs"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "tcp_alb_public_in" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_public.id
}

resource "aws_security_group_rule" "tcp_alb_public_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"   # allowed all 
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_public.id
}

# SG private
resource "aws_security_group" "alb_private" {
  name        = "private_alb_ecs"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "tcp_alb_private_in" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"   # allowed all
  source_security_group_id       = aws_security_group.alb_public.id
  security_group_id = aws_security_group.alb_private.id
}

resource "aws_security_group_rule" "tcp_alb_private_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"   # allowed all 
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_private.id
}