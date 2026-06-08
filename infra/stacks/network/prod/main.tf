locals {
  tags = merge(
    {
      owner               = var.owner
      environment         = var.environment
      cost-center         = var.cost_center
      application         = var.application
      data-classification = var.data_classification
      managed-by          = "terraform"
      stack               = "network"
    },
    var.additional_tags
  )
}

module "vpc" {
  source = "../../modules/network/aws-vpc"

  name_prefix          = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  tags                 = local.tags
}
