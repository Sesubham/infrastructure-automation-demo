terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
    }
  }
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  environment          = var.environment
  project_name        = var.project_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = data.aws_availability_zones.available.names
}

# Security Module
module "security" {
  source = "./modules/security"
  
  environment  = var.environment
  project_name = var.project_name
  vpc_id      = module.vpc.vpc_id
}

# S3 Module
module "s3" {
  source = "./modules/s3"
  
  environment  = var.environment
  project_name = var.project_name
  account_id   = data.aws_caller_identity.current.account_id
}

# EKS Module
module "eks" {
  source = "./modules/eks"
  
  environment           = var.environment
  project_name         = var.project_name
  cluster_name         = var.cluster_name
  cluster_version      = var.cluster_version
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  public_subnet_ids    = module.vpc.public_subnet_ids
  node_security_group_id = module.security.node_security_group_id
  cluster_security_group_id = module.security.cluster_security_group_id
  
  node_groups = var.node_groups
}

# ECR Repository
resource "aws_ecr_repository" "app_repo" {
  name                 = "${var.project_name}-${var.environment}"
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }
  
  encryption_configuration {
    encryption_type = "AES256"
  }
}

# ECR Lifecycle Policy
resource "aws_ecr_lifecycle_policy" "app_repo_policy" {
  repository = aws_ecr_repository.app_repo.name
  
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Delete untagged images older than 1 day"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
