# dui-terraform-gcp-project-iam
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.40.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 5.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.40.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.account_iam_members](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_accounts"></a> [accounts](#input\_accounts) | A map of principals to their configuration | <pre>map(object({<br>    principal_type            = string<br>    roles                     = list(string)<br>    is_google_service_account = optional(bool, false) # Renamed for better clarity<br>    project_id                = optional(string)<br>    project_number            = optional(string)<br>    service                   = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_project"></a> [project](#input\_project) | The project configuration containing the project\_id and project\_number | <pre>object({<br>    project_id     = string<br>    project_number = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam"></a> [iam](#output\_iam) | The IAM information. |
<!-- END_TF_DOCS -->