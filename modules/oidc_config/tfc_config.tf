# The workspace to attach OIDC config to. 
data "tfe_workspace" "my_workspace" {
  name         = "${var.workspace_name}"
  organization = var.terraform-org
}


# The following variables must be set to allow runs
# to authenticate to Vault.
#
resource "tfe_variable_set" "oidc_vars"{
  name = "${var.workspace_name}-oidc-config"
  description = "OIDC config for the ${var.workspace_name} workspace"
  organization = var.terraform-org

}

resource "tfe_workspace_variable_set" "oidc_vars"{
  workspace_id=data.tfe_workspace.my_workspace.id
  variable_set_id=tfe_variable_set.oidc_vars.id
}

resource "tfe_variable" "enable_vault_provider_auth" {
  count = var.enable_vault_dynamic_workspace_creds == true ? 1 : 0
  workspace_id = data.tfe_workspace.my_workspace.id

  key      = "TFC_VAULT_PROVIDER_AUTH"
  value    = "true"
  category = "env"

  description = "Enable the Workload Identity integration for Vault."
  variable_set_id = tfe_variable_set.oidc_vars.id
}

resource "tfe_variable" "tfc_vault_addr" {
  count = var.enable_vault_dynamic_workspace_creds == true ? 1 : 0
  workspace_id = data.tfe_workspace.my_workspace.id

  key       = "TFC_VAULT_ADDR"
  value     = var.VAULT_ADDR
  category  = "env"
  sensitive = true

  description = "The address of the Vault instance runs will access."
  variable_set_id = tfe_variable_set.oidc_vars.id
}

resource "tfe_variable" "tf_var_vault_addr" {
  count = var.enable_vault_dynamic_workspace_creds == true ? 1 : 0
  workspace_id = data.tfe_workspace.my_workspace.id

  key       = "TF_VAR_VAULT_ADDR"
  value     = var.VAULT_ADDR
  category  = "env"
  sensitive = true

  description = "The address of the Vault instance runs will access."
  variable_set_id = tfe_variable_set.oidc_vars.id
}


resource "tfe_variable" "tfc_vault_role" {
  count = var.enable_vault_dynamic_workspace_creds == true ? 1 : 0
  workspace_id = data.tfe_workspace.my_workspace.id

  key      = "TFC_VAULT_RUN_ROLE"
  value    = vault_jwt_auth_backend_role.tfc-role[0].role_name
  category = "env"

  description = "The Vault role runs will use to authenticate."
  variable_set_id = tfe_variable_set.oidc_vars.id
}

 resource "tfe_variable" "tfc_vault_namespace" {
   count = var.enable_vault_dynamic_workspace_creds == true ? 1 : 0
   workspace_id = data.tfe_workspace.my_workspace.id

   key      = "TFC_VAULT_NAMESPACE"
   value    = "${var.HCP_ROOT_NAMESPACE}/${vault_namespace.tf_workspace[0].path_fq}"
   category = "env"

   description = "The Vault namespace to use, if not using the default"
   variable_set_id = tfe_variable_set.oidc_vars.id
 }

resource "tfe_variable" "tfc_vault_namespace_var" {
   count = var.enable_vault_dynamic_workspace_creds == true ? 1 : 0
   workspace_id = data.tfe_workspace.my_workspace.id

   key      = "TF_VAR_TFC_VAULT_NAMESPACE"
   value    = "${var.HCP_ROOT_NAMESPACE}/${vault_namespace.tf_workspace[0].path_fq}"
   category = "env"

   description = "The Vault namespace to use in a form that we can reference it in the workspace."
   variable_set_id = tfe_variable_set.oidc_vars.id
 }


 resource "tfe_variable" "tfc_vault_auth_path" {
   count = var.enable_vault_dynamic_workspace_creds == true ? 1 : 0
   workspace_id = data.tfe_workspace.my_workspace.id
 
   key      = "TFC_VAULT_AUTH_PATH"
   value    = vault_jwt_auth_backend.tfc-jwt[0].path
   category = "env"

   description = "The path where the jwt auth backend is mounted, if not using the default"
   variable_set_id = tfe_variable_set.oidc_vars.id
 }


###############################################
#  Now turn on workspace identity for AWS     #
###############################################
# The following variables must be set to allow runs
# to authenticate to AWS.

resource "tfe_variable" "enable_aws_provider_auth" {
  count = var.enable_aws_dynamic_workspace_creds == true ? 1 : 0
  #workspace_id =data.tfe_workspace.my_workspace.id

  key      = "TFC_AWS_PROVIDER_AUTH"
  value    = "true"
  category = "env"

  description = "Enable the Workload Identity integration for AWS."
  variable_set_id = tfe_variable_set.oidc_vars.id
}

resource "tfe_variable" "tfc_aws_role_arn" {
  count = var.enable_aws_dynamic_workspace_creds == true ? 1 : 0
  #workspace_id =data.tfe_workspace.my_workspace.id

  key      = "TFC_AWS_RUN_ROLE_ARN"
  value    = aws_iam_role.tfc_role[count.index].arn
  category = "env"

  description = "The AWS role arn runs will use to authenticate."
  variable_set_id = tfe_variable_set.oidc_vars.id
}


##################################################################
##### Workload Identity support for GCP ##########################
##################################################################
resource "tfe_variable" "enable_gcp_provider_auth" {
  count = var.enable_gcp_dynamic_workspace_creds == true ? 1 : 0
  #workspace_id =data.tfe_workspace.my_workspace.id

  key      = "TFC_GCP_PROVIDER_AUTH"
  value    = "true"
  category = "env"

  description = "Enable the Workload Identity integration for GCP."
  variable_set_id = tfe_variable_set.oidc_vars.id
}

# The provider name contains the project number, pool ID,
# and provider ID. This information can be supplied using
# this TFC_GCP_WORKLOAD_PROVIDER_NAME variable, or using
# the separate TFC_GCP_PROJECT_NUMBER, TFC_GCP_WORKLOAD_POOL_ID,
# and TFC_GCP_WORKLOAD_PROVIDER_ID variables below if desired.
#
resource "tfe_variable" "tfc_gcp_workload_provider_name" {
  count = var.enable_gcp_dynamic_workspace_creds == true ? 1 : 0
  #workspace_id =data.tfe_workspace.my_workspace.id

  key      = "TFC_GCP_WORKLOAD_PROVIDER_NAME"
  value    =  google_iam_workload_identity_pool_provider.tfc_provider[count.index].name
  category = "env"

  description = "The workload provider name to authenticate against."
  variable_set_id = tfe_variable_set.oidc_vars.id
}

resource "tfe_variable" "tfc_gcp_service_account_email" {
  count = var.enable_gcp_dynamic_workspace_creds == true ? 1 : 0
  #workspace_id =data.tfe_workspace.my_workspace.id

  key      = "TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL"
  value    = google_service_account.tfc_service_account[count.index].email
  category = "env"

  description = "The GCP service account email runs will use to authenticate."
  variable_set_id = tfe_variable_set.oidc_vars.id
}

resource "tfe_variable" "tfc_gcp_project_id" {
  count = var.enable_gcp_dynamic_workspace_creds == true ? 1 : 0
  #workspace_id =data.tfe_workspace.my_workspace.id

  key      = "GCP_Project_ID"
  value    = var.gcp_project_id
  category = "terraform"

  description = "The GCP project ID that we use in the workspace"
  variable_set_id = tfe_variable_set.oidc_vars.id
}

