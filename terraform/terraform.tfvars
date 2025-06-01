aws_region        = "ap-south-1"
vpc_cidr          = "10.0.0.0/16"
subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
cluster_name      = "my-flask-cluster"
repository_name   = "my-flask-repo"

# EKS Node Group Settings
cluster_version   = "1.29"

desired_size      = 2
min_size          = 1
max_size          = 3

instance_types    = ["t3.medium"]
capacity_type     = "ON_DEMAND"
ami_type          = "AL2_x86_64"

create_iam_role   = true
iam_role_name     = "eks-flask-node-group-role"

cluster_service_cidr = "172.20.0.0/16"
