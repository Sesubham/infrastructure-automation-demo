variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "demo-webapp"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "demo-eks-cluster-prod"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "node_groups" {
  description = "EKS node group configurations"
  type = map(object({
    instance_types = list(string)
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
    capacity_type  = string
    disk_size     = number
    ami_type      = string
    labels        = map(string)
    taints        = list(object({
      key    = string
      value  = string
      effect = string
    }))
  }))
  default = {
    main = {
      instance_types = ["t3.large"]
      scaling_config = {
        desired_size = 3
        max_size     = 10
        min_size     = 3
      }
      capacity_type = "ON_DEMAND"
      disk_size     = 50
      ami_type      = "AL2_x86_64"
      labels = {
        role        = "main"
        environment = "prod"
      }
      taints = []
    }
  }
}

