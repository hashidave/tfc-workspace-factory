##############################################################################
# Variables File
#
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

# should be dev or production
variable "environment"{
  default = "dev"
}

variable tfc_hostname {
  description = "the default tfc hostname"
  default="app.terraform.io"
}

variable "terraform-org"{
  default=""
}

variable "HCP_Packer_RunTask_ID"{
  description = "Since almost everything I do needs packer, go ahead & link in the Run Task"
  default=""

}


variable VAULT_ADDR{
  default=""
}

# what is this?
#variable TFC_VAULT_RUN_ROLE {
#  default=""
#}

variable Use_AWS{
  description =  "If we are using AWS at all, turn this on."  
}

variable "tfc_aws_audience" {
  type        = string
  default     = "aws.workload.identity"
  description = "The audience value to use in run identity tokens.  Only required if we are using AWS."
}

variable Use_GCP{
  description =  "If we are using GCP at all, turn this on."  
}