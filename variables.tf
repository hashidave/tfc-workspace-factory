##############################################################################
# Variables File
#
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

# should be dev or production
variable "environment"{
  default = "dev"
}

variable "terraform-org"{
  default="hashi-DaveR"
}
# The audience of the ideneity token
variable TFC_WORKLOAD_IDENTITY_AUDIENCE{
  #recommended default from the docs
  default="vault.workload.identity"
}

variable VAULT_ADDR{
  default="https://hashiDaveR-vault-cluster-public-vault-f886c6aa.441332cd.z1.hashicorp.cloud:8200"
}

variable TFC_VAULT_RUN_ROLE {
  default=""
}

variable HCP_ROOT_NAMESPACE{
  default = "admin"
}

variable VAULT_NAMESPACE {
  default="terraform_workloads" 
}

variable tfc_hostname {
  default="app.terraform.io"
}

# This is a list of workspaces that we create with bootstrapped Vault dynamic creds
# you'll need a name, a project name, and a vault secret path that it can access.
variable tf-workspaces {
  type = list(map(string))
  default= [
     {workspace="workspace1", project_name="Unit Testing", project="prj-PWoNxUybpnpn858h"} 
  ]        
}