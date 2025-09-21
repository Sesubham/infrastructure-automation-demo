terraform {
  required_version = ">= 1.0"
  
#  required_providers {
#    aws = {
#      source  = "hashicorp/aws"
#      version = "~> 5.0"
#    }
#    kubernetes = {
#      source  = "hashicorp/kubernetes"
#      version = "~> 2.23"
#    }
#    helm = {
#      source  = "hashicorp/helm"
#      version = "~> 2.11"
#    }
#  }
}

# Provider configuration
#provider "aws" {
#  region = var.aws_region
  
#  default_tags {
#    tags = {
#      Environment = var.environment
#      Project     = var.project_name
#      ManagedBy   = "Terraform"
#    }
#  }
# }

# Kubernetes provider configuration
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

# Helm provider configuration
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}
