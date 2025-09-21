terraform {
  required_version = ">= 1.0"
  
  backend "s3" {
    bucket         = "demo-webapp-terraform-state-dev"
    key            = "dev/terraform.tfstate"
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
