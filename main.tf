#
# Required Providers
#
provider "hcp" {}

/*  we can't be our own grandpaw so I took this out 
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
*/

##########################################
## Set up a couple of things in AWS.  ####
##########################################
# Data source used to grab the TLS certificate for Terraform Cloud.
#
# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate
data "tls_certificate" "tfc_certificate" {
  count = var.Use_AWS == true || var.Use_GCP == true ? 1 : 0
  url = "https://${var.tfc_hostname}"
}
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider
resource "aws_iam_openid_connect_provider" "tfc_provider" {
  count = var.Use_AWS == true ? 1 : 0
  url             = data.tls_certificate.tfc_certificate[count.index].url
  client_id_list  = [var.tfc_aws_audience]
  thumbprint_list = [data.tls_certificate.tfc_certificate[count.index].certificates[0].sha1_fingerprint]
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

  # AWS Stuff
  enable_aws_dynamic_workspace_creds=true
  aws_oidc_provider_arn = aws_iam_openid_connect_provider.tfc_provider[0].arn
  aws_oidc_provider_client_id_list = aws_iam_openid_connect_provider.tfc_provider[0].client_id_list

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
  enable_aws_dynamic_workspace_creds=false
  # AWS Creds 
  #vault_dynamic_creds_master_user = data.tfe_outputs.core-network.values.vault_dynamic_creds_master_user.name
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
  enable_gcp_dynamic_workspace_creds=true
  gcp_project_id="mystical-glass-360520"
}


###########################################
#### JWT Auth Demo ########################
###########################################
module "vault_jwt_auth"{
  source = "./modules/tfc_workspace_env"
   
  workspace_name = "vault-jwt-auth-demo"
  environment = var.environment
  terraform-org  = var.terraform-org
  project_id="prj-U4CxHfAf34u3JfC1"
  project_name="Various Demos"
  VAULT_ADDR =var.VAULT_ADDR
  VAULT_NAMESPACE = "terraform_workloads"
  
}