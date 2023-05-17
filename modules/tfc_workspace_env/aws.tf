# AWS configuration
# This is optional & is controlled by the enable_aws_dynamic_workspace_creds module input (true/false)

# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0


# Data source used to grab the TLS certificate for Terraform Cloud.
#
# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate
data "tls_certificate" "tfc_certificate" {
  count = var.enable_aws_dynamic_workspace_creds == true ? 1 : 0
  url = "https://${var.tfc_hostname}"
}

# Creates an OIDC provider which is restricted to
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider
resource "aws_iam_openid_connect_provider" "tfc_provider" {
  count = var.enable_aws_dynamic_workspace_creds == true ? 1 : 0
  url             = data.tls_certificate.tfc_certificate[count.index].url
  client_id_list  = [var.tfc_aws_audience]
  thumbprint_list = [data.tls_certificate.tfc_certificate[count.index].certificates[0].sha1_fingerprint]
}

# Creates a role which can only be used by the specified Terraform
# cloud workspace.
#
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "tfc_role" {
  count = var.enable_aws_dynamic_workspace_creds == true ? 1 : 0
  name = "${var.workspace_name}-${var.environment}-tfc-role"
  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "${aws_iam_openid_connect_provider.tfc_provider[count.index].arn}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "${var.tfc_hostname}:aud": "${one(aws_iam_openid_connect_provider.tfc_provider[count.index].client_id_list)}",
            "${var.tfc_hostname}:aud": "${var.tfc_aws_audience}"
          },
          "StringLike": {
            "${var.tfc_hostname}:sub": "organization:${var.terraform-org}:project:${var.project_name}:workspace:${var.workspace_name}-${var.environment}:run_phase:*"
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
  name        = "${var.workspace_name}-${var.environment}-tfc-policy"
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