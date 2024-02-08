resource "aws_db_subnet_group" "terra-vpro-rds-subgrp" {
  name       = "terra-vpro-rds-subgrp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
  tags = {
    Name = "RDS subnet group"
  }
}

resource "aws_elasticache_subnet_group" "terra-vpro-cache-subgrp" {
  name = terra-vpro-cache-subgrp
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
  tags = {
    Name = "CACHE subnet group"
  }
}

resource "aws_db_instance" "vprofile-rds" {
  instance_class = "db.t2.micro"
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.6.34"
  db_name = var.dbname
  username = var.dbuser
  password = var.dbpass
  parameter_group_name = "default.mysql5.6"
  multi_az = "false"
  publicly_accessible = "false"
  skip_final_snapshot = true #always say false in real life since you do need the snapshots
  db_subnet_group_name = aws_db_subnet_group.terra-vpro-rds-subgrp.name
  vpc_security_group_ids = [aws_security_group.terraform-vpro-backend-sg.id]
  }

resource "aws_elasticache_cluster" "terra-vpro-cache" {
  cluster_id = "vprofile-cache"
  engine = "memcached"
  node_type = "cache.t2.micro"
  num_cache_nodes = 1
  parameter_group_name = "default.memcached1.5"
  port = 11211
  security_group_ids = [aws_security_group.terraform-vpro-backend-sg.id]
  subnet_group_name = aws_elasticache_subnet_group.terra-vpro-cache-subgrp.name
}

resource "aws_mq_broker" "terra-vpro-mq" {
  broker_name        = "terra-vpro-mq"
  engine_type        = "ActiveMQ"
  engine_version     = "5.15.0"
  host_instance_type = "mq.t2.micro"
  security_groups = [aws_security_group.terraform-vpro-backend-sg.id]
  subnet_ids = [module.vpc.private_subnets[0]]
  user {
    username = var.rmquser
    password = var.rmqpass
  }
}