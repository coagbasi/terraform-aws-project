resource "aws_elastic_beanstalk_environment" "vprofile-bean-prod" {
  name                = "vprofile-bean-prod"
  application         = aws_elastic_beanstalk_application.terra-prod.name
  solution_stack_name = "64bit Amazon Linux 2023 v5.1.3 running Tomcat 9 Corretto 11"
  cname_prefix        = "terra-bean-prod-domain"
  setting {
    name      = "VPCId"
    namespace = "aws:ec2:vpc"
    value     = module.vpc.vpc_id
  }

  setting {
    name      = "AssociatePublicIpAddress"
    namespace = "aws:ec2:vpc"
    value     = "false"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elbean-ec2-role"
  }

  setting {
    name      = "Subnets"
    namespace = "aws:ec2:vpc"
    value     = join(",", [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]])
  }

  setting {
    name      = "ELBSubnets"
    namespace = "aws:ec2:vpc"
    value     = join(",", [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]])
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    name      = "EC2KeyName"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = aws_key_pair.vprofilekey.key_name
  }

  setting {
    name      = "Availability Zones"
    namespace = "aws:autoscaling:asq"
    value     = "Any 3"
  }

  setting {
    name      = "MinSize"
    namespace = "aws:autoscaling:asq"
    value     = "1"
  }

  setting {
    name      = "MaxSize"
    namespace = "aws:autoscaling:asq"
    value     = "8"
  }

  setting {
    name      = "environment"
    namespace = "aws:elasticbeanstalk:application:environment"
    value     = "prod"
  }

  setting {
    name      = "LOGGING_APPENDER"
    namespace = "aws:elasticbeanstalk:application:environment"
    value     = "GRAYLOG"
  }

  setting {
    name      = "SystemType"
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    value     = "enhanced"
  }

  setting {
    name      = "RollingUpdateEnabled"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "true"
  }

  setting {
    name      = "RollingUpdateType"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "Health"
  }

  setting {
    name      = "MaxBatchSize"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "1"
  }

  setting {
    name      = "CrossZone"
    namespace = "aws:elb:loadbalancer"
    value     = "true"
  }

  setting {
    name      = "BatchSizeType"
    namespace = "aws:elasticbeanstalk:command"
    value     = "Fixed"
  }

  setting {
    name      = "StickinessEnabled"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "true"
  }

  setting {
    name      = "DeploymentPolicy"
    namespace = "aws:elasticbeanstalk:command"
    value     = "Rolling"
  }

  setting {
    name      = "SecurityGroups"
    namespace = "aws:elbv2:loadbalancer"
    value     = aws_security_group.terraform-vpro-bean-sg.id
  }

  setting {
    name      = "SecurityGroups"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = aws_security_group.terraform-vpro-prod-sg.id
  }

  depends_on = [aws_security_group.terraform-vpro-bean-sg, aws_security_group.terraform-vpro-prod-sg]
}
