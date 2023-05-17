
# Create a namespace for this workspace
resource "vault_namespace" "tf_workspace" {
  
  namespace = var.VAULT_NAMESPACE
  path="${var.workspace_name}-${var.environment}"
}

resource "vault_jwt_auth_backend" "tfc-jwt" {
    namespace = vault_namespace.tf_workspace.path_fq
    
    
    path                = "jwt-tf"
    oidc_discovery_url  = "https://app.terraform.io"
    bound_issuer        = "https://app.terraform.io"
}


# stand up a backend role for each of the workspaces
# in var.
resource "vault_jwt_auth_backend_role" "tfc-role" {
  namespace = vault_namespace.tf_workspace.path_fq
  
  backend         = vault_jwt_auth_backend.tfc-jwt.path
  role_name       = "tfc-role-${var.workspace_name}"
  token_policies  = ["default", vault_policy.tfc-policy.name]

  bound_audiences = ["vault.workload.identity"]
  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:${var.terraform-org}:project:${var.project_name}:workspace:${var.workspace_name}-${var.environment}:run_phase:*"
  }
  user_claim      = "terraform_full_workspace"
  role_type       = "jwt"
  token_ttl       = "600"
  token_max_ttl   = "900"
}

#################################################
####  Vault policies for the workspace##
#################################################
resource "vault_policy" "tfc-policy" {
  name = "tfc-policy-${var.workspace_name}-${var.environment}"
  namespace = vault_namespace.tf_workspace.path_fq
  
  policy = var.default-vault-policy
# TF has dependency issues...

  depends_on =[vault_namespace.tf_workspace]
}


#################################################
####  Everything below here is an "optional"  ###
####  feature that may not be present in      ###
####  every workspace                         ###
#################################################
# Generate access creds for our master user
#resource "aws_iam_access_key" "aws_master_key" {
#  count = var.vault_enable_aws_dynamic_secrets ==true ? 1 : 0  
#  user = var.vault_dynamic_creds_master_user
#}


# Enable the AWS Secrets engine if it's part of the input
#resource "vault_aws_secret_backend" "aws_secrets" {
#  count = var.vault_enable_aws_dynamic_secrets == true ? 1 : 0  
#  access_key = aws_iam_access_key.aws_master_key[count.index].id
#  secret_key = aws_iam_access_key.aws_master_key[count.index].secret
#}

