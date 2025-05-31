provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source     = "./modules/vpc"
  vpc_cidr   = var.vpc_cidr
  subnet_cidrs = var.subnet_cidrs
}

module "eks" {
  source         = "./modules/eks"
  cluster_name   = var.cluster_name
  subnet_ids     = module.vpc.subnet_ids
  vpc_id         = module.vpc.vpc_id
}
 
module "ecr" {
  source          = "./modules/ecr"
  repository_name = var.repository_name
}


