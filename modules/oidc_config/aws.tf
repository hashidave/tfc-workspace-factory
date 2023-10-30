# AWS configuration
# This is optional & is controlled by the enable_aws_dynamic_workspace_creds module input (true/false)

# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0




# Creates a role which can only be used by the specified Terraform
# cloud workspace.
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "tfc_role" {
  count = var.enable_aws_dynamic_workspace_creds == true ? 1 : 0
  name = "${var.workspace_name}-tfc-role"
  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "${var.aws_oidc_provider_arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${var.tfc_hostname}:aud": "${one(var.aws_oidc_provider_client_id_list)}"
          },
          "StringLike": {
            "${var.tfc_hostname}:sub": "organization:${var.terraform-org}:project:${var.project_name}:workspace:${var.workspace_name}:run_phase:*"
          }
        }
      }
    ]
    }
  EOF

}

# Creates a policy that will be used to define the permissions that
# the previously created role has within AWS.
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "tfc_policy" {
  count = var.enable_aws_dynamic_workspace_creds == true ? 1 : 0
  name        = "${var.workspace_name}-tfc-policy"
  description = "TFC run policy"

  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Effect": "Allow",
     "Action": [
       "*"
     ],
     "Resource": "*"
   }
 ]
}
EOF
}


# Creates an attachment to associate the above policy with the
# previously created role.
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "tfc_policy_attachment" {
  count = var.enable_aws_dynamic_workspace_creds == true ? 1 : 0
  role       = aws_iam_role.tfc_role[count.index].name
  policy_arn = aws_iam_policy.tfc_policy[count.index].arn
}