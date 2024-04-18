iprovider "aws" {
  region = "us-east-1"
}

#creating vpc
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs            = ["us-east-1a"]
  public_subnets = ["10.0.1.0/24"]

  enable_dns_hostnames = true
  tags = {
    Name        = "my-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
  public_subnet_tags = {
    Name = "jenkins-public"
  }
}


#creating Security group
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "user-service"
  description = "Security group"
  vpc_id      = module.vpc.vpc_id


  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [{
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = "0.0.0.0/0"
  }]
  tags = {
    Name = "jenkins-sg"
  }
}

#creating ec2 instance
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "jenkins-instance"

  instance_type               = "t2.medium"
  #ami=                          "ami-04e5276ebb8451442"
  key_name                    = "vinaybvkey"
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("jenkins-install.sh")
  availability_zone           = "us-east-1a"

  tags = {
    Name        = "jenkins-instance2"
    Terraform   = "true"
    Environment = "dev"
  }
}
