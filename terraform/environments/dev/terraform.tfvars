aws_region   = "us-west-2"
environment  = "dev"
project_name = "demo-webapp"

# Network settings
vpc_cidr = "10.0.0.0/16"

# EKS settings
cluster_name    = "demo-eks-cluster"
cluster_version = "1.28"

# Node group configurations
node_groups = {
  main = {
    instance_types = ["t3.small","t3a.small"]
    scaling_config = {
      desired_size = 2
      max_size     = 4
      min_size     = 1
    }
    capacity_type = "SPOT"
    disk_size     = 30
    ami_type      = "AL2_x86_64"
    labels = {
      role        = "main"
      environment = "dev"
    }
    taints = []
  }
}
