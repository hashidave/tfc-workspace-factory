# TFE_WORKSPACE_ENV Module

This module creates a Terraform workspace with an associated Vault namespace configured with jwt auth and Terraform Dynamic Workspace Credentials. 


## Inputs    
- terraform-org         - The name of your Terraform org
- workspace_name        - The name of the new workspace to create.  This is also the name of the associated Vault namespace.
- environment           - Should be dev/qa/test/prod/etc. This will be appended to the workspace and vault namespace names.
- project_id            - The Terraform project ID that will hold the new workspace.  
- project_name          - The name of the Terraform project that will hold the new workspace.  Yes, it's kind of redundant. 
- HCP_Packer_RunTask_ID - (optional) The ID of a Packer run task to associate with this workspace
- VAULT_ADDR            - The URL of your Vault instance
- VAULT_NAMESPACE       - This is the parent Vault namespace that will contain the newly created namespace for this workspace.
- vault_enable_aws_dynamic_secrets - Incomplete. Do not use. 

## Outputs
Currently none

## Example module usage
    module "consul-cluster"{
        source = "./modules/tfc_workspace_env"

        # terraform stuff   
        workspace_name      = "consul-cluster"
        terraform-org       = "My-Terraform-Org"
        environment         = "dev
        project_id          = "prj-mo2f5tw3bbZEFT7yQq"
        project_name        = "Core Infra"
        HCP_Packer_RunTask_ID = var.HCP_Packer_RunTask_ID

        # vault stuff
        VAULT_ADDR =        "https://vault.mycompany.com:1801"
        VAULT_NAMESPACE = "terraform_workloads"
    }