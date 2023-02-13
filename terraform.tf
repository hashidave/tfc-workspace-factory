terraform {
  required_providers {
    boundary = {
      source  = "hashicorp/boundary"
    }
  }
  cloud {
    organization = "hashi-DaveR"
    hostname     = "app.terraform.io"

    workspaces {
      tags = ["tfc-workspace-factory"]
    }
 }
}


data "tfe_workspace" "current_workspace"{
  name=terraform.workspace
  organization = var.terraform-org
}

