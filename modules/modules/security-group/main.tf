resource "aws_security_group" "security_group" {
  description = var.description
  name   = var.name
  vpc_id = var.vpc_id
  tags = {
    Name = var.name
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group_rule" "ingress-roule" {
  count = length(compact(var.allowed_ports))
  type = "ingress"

  from_port = element(var.allowed_ports, count.index)
  to_port   = element(var.allowed_ports, count.index)
  protocol  = var.protocol
  cidr_blocks = var.allowed_ip

  security_group_id = aws_security_group.security_group.id
}


resource "aws_security_group_rule" "egress" {
  type = "egress"

  from_port = 0
  to_port = 0
  protocol = "-1"

  cidr_blocks = [
    "0.0.0.0/0"]

  security_group_id = aws_security_group.security_group.id
}

