# GCP configuration
# This is optional & is controlled by the enable_gcp_dynamic_workspace_creds module input (true/false)

# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0


/* provider "google" {
  project = var.gcp_project_id
  region  = "global"
}

provider "google-beta" {
  project = var.gcp_project_id
  region  = "global"
}
 */
# Data source used to get the project number programmatically.
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project
data "google_project" "project" { 
    count = var.enable_gcp_dynamic_workspace_creds == true ? 1 : 0
    project_id=var.gcp_project_id
}


# Creates an identity pool provider which uses an attribute condition
# to ensure that only the specified Terraform Cloud workspace will be
# able to authenticate to GCP using this provider.
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider
resource "google_iam_workload_identity_pool_provider" "tfc_provider" {
  count = var.enable_gcp_dynamic_workspace_creds == true ? 1 : 0
  provider                           = google-beta
  project = var.gcp_project_id
  workload_identity_pool_id          = var.gcp_identity_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "${var.environment}-${var.workspace_name}-tf-provider"
  attribute_mapping = {
    "google.subject"                        = "assertion.sub",
    "attribute.aud"                         = "assertion.aud",
    "attribute.terraform_run_phase"         = "assertion.terraform_run_phase",
    "attribute.terraform_project_id"        = "assertion.terraform_project_id",
    "attribute.terraform_project_name"      = "assertion.terraform_project_name",
    "attribute.terraform_workspace_id"      = "assertion.terraform_workspace_id",
    "attribute.terraform_workspace_name"    = "assertion.terraform_workspace_name",
    "attribute.terraform_organization_id"   = "assertion.terraform_organization_id",
    "attribute.terraform_organization_name" = "assertion.terraform_organization_name",
    "attribute.terraform_run_id"            = "assertion.terraform_run_id",
    "attribute.terraform_full_workspace"    = "assertion.terraform_full_workspace",
  }
  oidc {
    issuer_uri        = "https://${var.tfc_hostname}"
    # The default audience format used by TFC is of the form:
    # //iam.googleapis.com/projects/{project number}/locations/global/workloadIdentityPools/{pool ID}/providers/{provider ID}
    # which matches with the default accepted audience format on GCP.
    #
    # Uncomment the line below if you are specifying a custom value for the audience instead of using the default audience.
    # allowed_audiences = [var.tfc_gcp_audience]
  }
  attribute_condition = "assertion.sub.startsWith(\"organization:${var.terraform-org}:project:${var.project_name}:workspace:${var.workspace_name}\")"
}

# Creates a service account that will be used for authenticating to GCP.
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "tfc_service_account" {
  count = var.enable_gcp_dynamic_workspace_creds == true ? 1 : 0
  account_id   = "${var.environment}-${var.workspace_name}-tfc-service"
  project = var.gcp_project_id
  display_name = "Terraform Cloud Service Account" 
}

# Allows the service account to act as a workload identity user.
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
resource "google_service_account_iam_member" "tfc_service_account_member" {
  count = var.enable_gcp_dynamic_workspace_creds == true ? 1 : 0
  service_account_id = google_service_account.tfc_service_account[count.index].name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${var.gcp_identity_pool.name}/*"
}

# Updates the IAM policy to grant the service account permissions
# within the project.
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "tfc_project_member" {
  count = var.enable_gcp_dynamic_workspace_creds == true ? 1 : 0
  project = var.gcp_project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.tfc_service_account[count.index].email}"
}



