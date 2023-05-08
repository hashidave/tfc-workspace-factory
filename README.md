# The TFC Workspace Factory
Sets up TF workspaces that are ready to go with their own Dynamic Workload Credentials doled out by HCP vault.

Variables are defaulted for me so you'll need to make meaningful
overrides as necesary. Particularly
- terraform-org - your org name
- environment - typically dev/qa/prod.  This will be appended to namespaces, workspaces, etc. 
- HCP_Packer_RunTask_ID - If you use Packer a lot, go ahead & put in your runtask ID.  Leave blank otherwise. 


Workspaces are created using a module called tfc_workspace_env.  Provide inputs to create the workspace to your specs.  See modules/tfc_workspace_env/README.md for details

Here's an example that creates a workspace called "consul-cluster"

    module "consul-cluster"{
        source = "./modules/tfc_workspace_env"

        # terraform stuff   
        workspace_name = "consul-cluster"
        terraform-org  = var.terraform-org
        environment = var.environment
        project_id="prj-mo2f5NUw3CFT7yQq"
        project_name="Core Infra"
        HCP_Packer_RunTask_ID=var.HCP_Packer_RunTask_ID

        # vault stuff
        VAULT_ADDR =var.VAULT_ADDR
        VAULT_NAMESPACE = "terraform_workloads"
        vault_enable_aws_dynamic_secrets=true  
    }



This is best run locally as you'll need a highly-privileged vault user.   




