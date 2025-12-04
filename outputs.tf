# Other workspaces may need this
#output "oidc_provider"{
#  value=aws_iam_openid_connect_provider.tfc_provider
#}

#output policies {
#  value= module.terraform-aws.polices
#}

/*
output "main-namespace"{
  value = vault_namespace.tf_namespace.path_fq

}

output "workspace-namespaces"{
  value = vault_namespace.tf_workspace[*].path
}

output "sub" {
  value = vault_jwt_auth_backend_role.tfc-role[*].bound_claims.sub
}

#output "auth-method"{
#  value= 
#}
*/