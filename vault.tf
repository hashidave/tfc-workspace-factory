resource "vault_namespace" "tf_namespace" {
  #namespace= var.HCP_ROOT_NAMESPACE
  path = var.VAULT_NAMESPACE
}

# Create a namespace for each workspace
resource "vault_namespace" "tf_workspace" {
  count=length (var.tf-workspaces)
  namespace = vault_namespace.tf_namespace.path_fq
  path="${var.tf-workspaces[count.index].workspace}-${var.environment}"
}

resource "vault_jwt_auth_backend" "tfc-jwt" {
    namespace = vault_namespace.tf_workspace[count.index].path_fq
    count=length (var.tf-workspaces)
    
    path                = "jwt-tf"
    oidc_discovery_url  = "https://app.terraform.io"
    bound_issuer        = "https://app.terraform.io"
}


# stand up a backend role for each of the workspaces
# in var.tf-workspaces
resource "vault_jwt_auth_backend_role" "tfc-role" {
  namespace = vault_namespace.tf_workspace[count.index].path_fq
  count=length (var.tf-workspaces)
  backend         = vault_jwt_auth_backend.tfc-jwt[count.index].path
  role_name       = "tfc-role-${var.tf-workspaces[count.index].workspace}"
  token_policies  = ["default", "tfc-policy-${var.tf-workspaces[count.index].workspace}-${var.environment}"]

  bound_audiences = ["vault.workload.identity"]
  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:${var.terraform-org}:project:${var.tf-workspaces[count.index].project_name}:workspace:${var.tf-workspaces[count.index].workspace}-${var.environment}:run_phase:*"
  }
  user_claim      = "terraform_full_workspace"
  role_type       = "jwt"
  token_ttl       = "600"
  token_max_ttl   = "900"
}


#################################################
####  Vault policies for the various workspaces##
#################################################
resource "vault_policy" "terraform-rds" {
  name = "tfc-policy-terraform-rds-${var.environment}"
  namespace = "${vault_namespace.tf_namespace.path}/terraform-rds-${var.environment}"
  
  policy = var.default-vault-policy
# TF has dependency issues...

  depends_on =[vault_namespace.tf_workspace]
}



resource "vault_policy" "terraform-aws" {
  name = "tfc-policy-terraform-aws-${var.environment}"
  namespace = "${vault_namespace.tf_namespace.path}/terraform-aws-${var.environment}"
  
  policy = var.default-vault-policy
# TF has dependency issues...
  depends_on =[vault_namespace.tf_workspace]
}

resource "vault_policy" "networks" {
  name = "tfc-policy-networks-${var.environment}"
  namespace = "${vault_namespace.tf_namespace.path}/networks-${var.environment}"
  
  policy = var.default-vault-policy
# TF has dependency issues...
  depends_on =[vault_namespace.tf_workspace]
}

resource "vault_policy" "consul-cluster" {
  name = "consul-cluster-${var.environment}"
  namespace = "${vault_namespace.tf_namespace.path}/consul-cluster-${var.environment}"
  
  policy = var.default-vault-policy
# TF has dependency issues...
  depends_on =[vault_namespace.tf_workspace]
}



