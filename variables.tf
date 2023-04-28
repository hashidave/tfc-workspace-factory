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
  default=""
}

variable "HCP_Packer_RunTask_ID"{
  description = "Since almost everything I do needs packer, go ahead & link in the Run Task"
  default=""

}

/*
# The audience of the ideneity token
variable TFC_WORKLOAD_IDENTITY_AUDIENCE{
  #recommended default from the docs
  default="vault.workload.identity"
}
*/

variable VAULT_ADDR{
  default=""
}

# what is this?
variable TFC_VAULT_RUN_ROLE {
  default=""
}
/*
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
# IMPORTANT: Leave the environment (dev/qa/prod) off of the workspace name
variable tf-workspaces {
  type = list(map(string))
  default= [
     {workspace="workspace1", project_name="Default", project="default", needs_aws_dynamic_creds=1},
     {workspace="fixit", project_name="Default", project="default"} 
  ]        
}


variable default-vault-policy{
  default= <<EOT
# Used to generate child tokens in vault
path "auth/token/create" {
  capabilities = ["sudo", "create", "read", "update", "list"]
}
# Used by the token to query itself
path "auth/token/lookup-self" {
  capabilities = ["read"]
}
path "*" {
	capabilities = ["read","create","update","delete","list","patch"]
}

path "sys/mounts/*" {
  capabilities = ["create", "update", "delete"]
}
path "sys/leases/revoke" {
  capabilities = ["update"]
}
EOT

}
*/