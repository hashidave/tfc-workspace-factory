output "main-namespace"{
  value = vault_namespace.tf_namespace.path_fq

}

output "workspace-namespaces"{
  value = vault_namespace.tf_workspace[*].path
}

output "sub" {
  value = vault_jwt_auth_backend_role.tfc-role[*].bound_claims.sub
}