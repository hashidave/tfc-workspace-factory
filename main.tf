#
# Required Providers
#
provider "hcp" {}


module "networks"{
  source = "./modules/tfc_workspace_env"
   
  workspace_name = "networks"
  terraform-org  = var.terraform-org
  workspace_tags= ["networks"]
  environment = var.environment
  project_id="prj-mo2f5NUw3CFT7yQq"
  project_name="Core Infra"
  global_remote_state_sharing = true

  # Vault Requirements
  VAULT_ADDR =var.VAULT_ADDR
  VAULT_NAMESPACE = "terraform_workloads"
  
}


module "terraform-aws"{
  source = "./modules/tfc_workspace_env"
   
  # terraform stuff 
  workspace_name = "terraform-aws"
  workspace_tags = ["goldenimage-aws"]
  environment = var.environment
  terraform-org  = var.terraform-org
  project_id="prj-Ledw7n1QH4r6ygDJ"
  project_name="Golden Image Workflows"
  HCP_Packer_RunTask_ID=var.HCP_Packer_RunTask_ID
  
  # Vault Stuff
  VAULT_ADDR =var.VAULT_ADDR
  VAULT_NAMESPACE = "terraform_workloads"
}

module "consul-cluster"{
  source = "./modules/tfc_workspace_env"

  # terraform stuff   
  workspace_name = "consul-cluster"
  terraform-org  = var.terraform-org
  environment = var.environment
  project_id="prj-mo2f5NUw3CFT7yQq"
  project_name="Core Infra"
  HCP_Packer_RunTask_ID=var.HCP_Packer_RunTask_ID

  # vault stuff
  VAULT_ADDR =var.VAULT_ADDR
  VAULT_NAMESPACE = "terraform_workloads"
  vault_enable_aws_dynamic_secrets=true  
}

module "terraform_rds"{
  source = "./modules/tfc_workspace_env"
   
  workspace_name = "terraform-rds"
  workspace_tags= ["terraform-rds"]
  environment = var.environment
  terraform-org  = var.terraform-org
  project_id="prj-Ledw7n1QH4r6ygDJ"
  project_name="Golden Image Workflows"
  VAULT_ADDR =var.VAULT_ADDR
  VAULT_NAMESPACE = "terraform_workloads"
  HCP_Packer_RunTask_ID=var.HCP_Packer_RunTask_ID
}

module "terraform_gcp"{
  source = "./modules/tfc_workspace_env"
   
  workspace_name = "terraform-gcp"
  environment = var.environment
  terraform-org  = var.terraform-org
  project_id="prj-Ledw7n1QH4r6ygDJ"
  project_name="Golden Image Workflows"
  VAULT_ADDR =var.VAULT_ADDR
  VAULT_NAMESPACE = "terraform_workloads"
  HCP_Packer_RunTask_ID=var.HCP_Packer_RunTask_ID
}
