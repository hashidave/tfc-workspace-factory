##############################################################################
# Variables File
#
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

# should be dev or production
variable "environment"{
  description="The name of this environment.  Should conform to a dev/qa/prod-type semantics."
}

variable tfc_hostname{
  description = "Your terraform hostname.  Defaults to cloud provider"
  type = string
  default = "app.terraform.io"
}

variable "terraform-org"{
  description="The name of your TFCB Org"

}

variable "global_remote_state_sharing"{
  description = "Boolean that determines if we share this out globally."
  default=false
}

variable "HCP_Packer_RunTask_ID"{
  description = "Since almost everything I do needs packer, go ahead & link in the Run Task"
  default=""
}

variable HCP_Packer_Enforcement_Level {
    description = "the level of enforcement (advisory/mandatory/none)"
    default="advisory"
}

# The audience of the ideneity token
variable TFC_WORKLOAD_IDENTITY_AUDIENCE{
  description = "audience for VAULT oidc auth.  recommended not to change unless you know what you're doing"
  #recommended default from the docs
  default="vault.workload.identity"
}

variable VAULT_ADDR{
  description ="The address of your Vault instance"
}

# what is this?
variable TFC_VAULT_RUN_ROLE {
  default=""
}

variable HCP_ROOT_NAMESPACE{
  description = "the root namespace of your vault instance. Defaults to 'admin' for HCP vault"
  default = "admin"
}

variable VAULT_NAMESPACE {  
  description = "parent namespace in vault for the workspace generated by this module"  
  default="admin/terraform_workloads" 
}



variable workspace_name{
    description = "The name of the workspace to create"
}
variable workspace_tags{
    description = "a list of tag names to apply to the workspace"
    type = list(string)
    default=[]
}
variable project_name{
    description = "The the parent projct of the workspace"
}
variable project_id{
    description = "The id of the parent project"
}

variable vault_policies{
    description = "Additional vault policies needed for terraform to access secrets in the form {policy_name:policy-contents}"
    type=map(string)
    default={}
}

variable enable_aws_dynamic_workspace_creds{
  type=bool
  description = "Do we need Dynamic Workspace Credentials for AWS? true/false"
  default=false
}

variable aws_oidc_provider_arn{
  type = string
  description = "The oidc provider we are using for AWS.  Only required for AWS"
  default =""
}

variable aws_oidc_provider_client_id_list{
  type = list(string)
  description = "The oidc provider we are using for AWS.  Only required for AWS"
  default=[""]
}


variable tfc_aws_audience{
  description = "Default aws audience for tfc.  Don't change this unless you really need to."
  default ="aws.workload.identity"
}


#################################################
########  Dynamic Workspace creds for GCP #######
#################################################

variable enable_gcp_dynamic_workspace_creds{
  type=bool
  description = "Do we need Dynamic Workspace Credentials for GCP? true/false"
  default=false
}

variable gcp_project_id {
  type = string
  description = "The google project we want to set up auth for."
  default =""
}

variable "gcp_service_list" {
  description = "APIs required for the project"
  type        = list(string)
  default = [
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "sts.googleapis.com",
    "iamcredentials.googleapis.com"
  ]
}

/*
variable vault_dynamic_creds_master_user{
  type = string
  description = "This is the AWS account that vault uses to generate other credentials."
  default ="nobody"
}
*/

variable default-vault-policy{
  description = "the default Vault policy to apply to the Vault namespace."
  default= <<EOT

#Terraform is the de-facto terraform admin of the newly created namespace.
path "*" {
	capabilities = ["read","create","update","delete","list","patch", "sudo"]
}
EOT

}


variable "remote_state_ids"{
  default =["abcd","efgh"]
}

