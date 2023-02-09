# The TFC Workspace Factory
Sets up TF workspaces that are ready to go with their own Dynamic Workload Credentials doled out by HCP vault.

Variables are defaulted for me so you'll need to make meaningful
overrides as necesary. Particularly
- terraform-org - self-explanatory... i hope
- VAULT_ADDR - The address of your HCP Vault cluster.  If it's not HCP, also change the **HCP_ROOT_NAMESPACE** var to either blank or something that works in your env
- VAULT_NAMESPACE -I have this set up to create a master Vault namespace for all TF projects & then a sub-namespaces is created for each TF workspace.  
- tf-workspaces - This is the big one.  It's a list of maps that define each workspace.  Each one will require a **workspace**, a **project_name** and an id for the project named **project**.  Create one map per workspace that you need

The next thing you need to do is go into vault.tf & create a vault policy for each workspace. This policy will control what TF is allowed to do in the vault namespace that goes along with the workspace. I considered templatizing this but there are too many unknowns as to what your workspace might need to do in Vault.  

Make the policy as a vault_policy resource following the example code for **workspace1**. I gave it basically full control which isn't the most secure practice. YMMV.


This is best run locally as you'll need a highly-privileged vault user.  I auth locally to vault.  




