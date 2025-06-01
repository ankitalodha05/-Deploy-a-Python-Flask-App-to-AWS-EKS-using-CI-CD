module "eks_managed_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "~> 20.0"

  cluster_name         = var.cluster_name
  cluster_version      = var.cluster_version
  subnet_ids           = var.subnet_ids

  name                 = "flask-node-group"
  desired_size         = var.desired_size
  min_size             = var.min_size
  max_size             = var.max_size
  instance_types       = var.instance_types
  capacity_type        = var.capacity_type
  ami_type             = var.ami_type

  create_iam_role      = var.create_iam_role
  iam_role_name        = var.iam_role_name

  cluster_service_cidr = var.cluster_service_cidr  # 👈 ADD THIS
}
