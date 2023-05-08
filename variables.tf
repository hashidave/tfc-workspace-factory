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