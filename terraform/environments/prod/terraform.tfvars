aws_region   = "us-west-2"
environment  = "prod"
project_name = "demo-webapp"

# Network settings - Different CIDR to avoid conflicts
vpc_cidr = "10.1.0.0/16"

# EKS settings
cluster_name    = "demo-eks-cluster-prod"
cluster_version = "1.28"

# Node group configurations for production
node_groups = {
  main = {
    instance_types = ["t3.small","t3a.small"]
    scaling_config = {
      desired_size = 2
      max_size     = 3
      min_size     = 1
    }
    capacity_type = "SPOT"
    disk_size     = 50
    ami_type      = "AL2_x86_64"
    labels = {
      role        = "main"
      environment = "prod"
    }
    taints = []
  }
}
