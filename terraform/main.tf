provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source        = "./modules/vpc"
  vpc_cidr      = var.vpc_cidr
  subnet_cidrs  = var.subnet_cidrs
}

module "eks" {
  source        = "./modules/eks"
  cluster_name  = var.cluster_name
  subnet_ids    = module.vpc.subnet_ids
  vpc_id        = module.vpc.vpc_id
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = var.repository_name
}

module "eks_node_group" {
  source = "./modules/node-group"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  cluster_service_cidr   = var.cluster_service_cidr

  subnet_ids = module.vpc.subnet_ids

  desired_size    = 2
  min_size        = 1
  max_size        = 3

  instance_types  = ["t3.medium"]
  capacity_type   = "ON_DEMAND"
  ami_type        = "AL2_x86_64"

  create_iam_role = true
  iam_role_name   = "eks-flask-node-group-role"
}
