variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "cluster_security_group_id" {
  description = "Cluster security group ID"
  type        = string
}

variable "node_security_group_id" {
  description = "Node security group ID"
  type        = string
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
}
