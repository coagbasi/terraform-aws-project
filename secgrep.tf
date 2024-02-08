resource "aws_security_group" "terraform-vpro-bean-sg" {
  name        = "terraform-vpro-bean-sg"
  description = "Security group for bean-elb"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "terraform-vpro-bastion-sg" {
  name        = "terraform-vpro-bastion-sg"
  description = "Security group for bastionisioner ec2 instance"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.MYIP]
  }
}

resource "aws_security_group" "terraform-vpro-prod-sg" {
  name        = "terraform-vpro-prod-sg"
  description = "Security group for Beanstalk Instance"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    security_groups = [aws_security_group.terraform-vpro-bastion-sg.id]
  }
}

resource "aws_security_group" "terraform-vpro-backend-sg" {
  name        = "terraform-vpro-backend-sg"
  description = "Security group for elasticache, AmazonMQ & RDS"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    protocol        = "-1"
    to_port         = 0
    security_groups = [aws_security_group.terraform-vpro-prod-sg.id]
  }
}

resource "aws_security_group_rule" "sec_grep_allow_itself" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.terraform-vpro-backend-sg.id
  source_security_group_id = aws_security_group.terraform-vpro-backend-sg.id
}