terraform {
  required_version = ">= 1.0"
  
  backend "s3" {
    bucket         = "demo-webapp-terraform-state-prod"
    key            = "prod/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# Use the root module
module "infrastructure" {
  source = "../../"
  
  # Pass all variables to the root module
  aws_region      = var.aws_region
  environment     = var.environment
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  node_groups     = var.node_groups
}

# Output all values from the root module
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.infrastructure.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.infrastructure.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.infrastructure.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.infrastructure.private_subnet_ids
}

output "eks_cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.infrastructure.eks_cluster_endpoint
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.infrastructure.eks_cluster_name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.infrastructure.ecr_repository_url
}

output "s3_app_data_bucket" {
  description = "Name of the S3 bucket for application data"
  value       = module.infrastructure.s3_app_data_bucket
}

output "s3_logs_bucket" {
  description = "Name of the S3 bucket for logs"
  value       = module.infrastructure.s3_logs_bucket
}

