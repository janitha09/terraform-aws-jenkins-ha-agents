provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 0.12"

  required_providers {
    aws      = "2.25.0"
    template = "2.1.2"
  }
}

locals {
  tags = {
    contact     = var.contact
    environment = var.environment
  }
}

module "jenkins_ha_agents" {
  source  = "neiman-marcus/jenkins-ha-agents/aws"
  version = "2.1.0"

  admin_password  = var.admin_password
  bastion_sg_name = var.bastion_sg_name
  domain_name     = var.domain_name

  private_subnet_name = var.private_subnet_name
  public_subnet_name  = var.public_subnet_name

  r53_record = var.r53_record
  region     = var.region

  ssl_certificate = var.ssl_certificate
  ssm_parameter   = var.ssm_parameter

  tags     = local.tags
  vpc_name = var.vpc_name
}

