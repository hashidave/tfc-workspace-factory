# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "tfe" {
  hostname = var.tfc_hostname
}

# Runs in this workspace will be automatically authenticated
# to Vault with the permissions set in the Vault policy.
#
# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/workspace
resource "tfe_workspace" "my_workspace" {
  count = length (var.tf-workspaces)

  name         = "${var.tf-workspaces[count.index].workspace}-${var.environment}"
  organization = var.terraform-org
  project_id = var.tf-workspaces[count.index].project
}

  # Turn on the HCP Packer run task for everything. we need it every time.
resource"tfe_workspace_run_task" "hcp_packer" {
  count = length (var.tf-workspaces)
  workspace_id      = tfe_workspace.my_workspace[count.index].id
  task_id           = var.HCP_Packer_RunTask_ID
  enforcement_level = "mandatory"
}  


# The following variables must be set to allow runs
# to authenticate to Vault.
#
# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable
resource "tfe_variable" "enable_vault_provider_auth" {
  count = length (var.tf-workspaces)
  workspace_id = tfe_workspace.my_workspace[count.index].id

  key      = "TFC_VAULT_PROVIDER_AUTH"
  value    = "true"
  category = "env"

  description = "Enable the Workload Identity integration for Vault."
}

resource "tfe_variable" "tfc_vault_addr" {
  count = length (var.tf-workspaces)
  workspace_id = tfe_workspace.my_workspace[count.index].id

  key       = "TFC_VAULT_ADDR"
  value     = var.VAULT_ADDR
  category  = "env"
  sensitive = true

  description = "The address of the Vault instance runs will access."
}

resource "tfe_variable" "tf_var_vault_addr" {
  count = length (var.tf-workspaces)
  workspace_id = tfe_workspace.my_workspace[count.index].id

  key       = "TF_VAR_VAULT_ADDR"
  value     = var.VAULT_ADDR
  category  = "env"
  sensitive = true

  description = "The address of the Vault instance runs will access."
}



resource "tfe_variable" "tfc_vault_role" {
  count = length (var.tf-workspaces)
  workspace_id = tfe_workspace.my_workspace[count.index].id

  key      = "TFC_VAULT_RUN_ROLE"
  value    = vault_jwt_auth_backend_role.tfc-role[count.index].role_name
  category = "env"

  description = "The Vault role runs will use to authenticate."
}

# The following variables are optional; uncomment the ones you need!

 resource "tfe_variable" "tfc_vault_namespace" {
   count = length (var.tf-workspaces)
   workspace_id = tfe_workspace.my_workspace[count.index].id

   key      = "TFC_VAULT_NAMESPACE"
   value    = "${var.HCP_ROOT_NAMESPACE}/${vault_namespace.tf_workspace[count.index].path_fq}"
   category = "env"

   description = "The Vault namespace to use, if not using the default"
 }

resource "tfe_variable" "tfc_vault_namespace_var" {
   count = length (var.tf-workspaces)
   workspace_id = tfe_workspace.my_workspace[count.index].id

   key      = "TF_VAR_TFC_VAULT_NAMESPACE"
   value    = "${var.HCP_ROOT_NAMESPACE}/${vault_namespace.tf_workspace[count.index].path_fq}"
   category = "env"

   description = "The Vault namespace to use in a form that we can reference it in the workspace."
 }


 resource "tfe_variable" "tfc_vault_auth_path" {
   count = length (var.tf-workspaces)
   workspace_id = tfe_workspace.my_workspace[count.index].id
 
   key      = "TFC_VAULT_AUTH_PATH"
   value    = vault_jwt_auth_backend.tfc-jwt[count.index].path
   category = "env"

   description = "The path where the jwt auth backend is mounted, if not using the default"
 }

# resource "tfe_variable" "tfc_vault_audience" {
#   workspace_id = tfe_workspace.my_workspace.id

#   key      = "TFC_VAULT_WORKLOAD_IDENTITY_AUDIENCE"
#   value    = var.tfc_vault_audience
#   category = "env"

#   description = "The value to use as the audience claim in run identity tokens"
# }
