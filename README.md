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
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.40.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.iam_members](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_iam_members"></a> [iam\_members](#input\_iam\_members) | A list of members and their IAM roles. | <pre>list(object({<br>    id     = string<br>    member = string<br>    roles  = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_iam_service_accounts"></a> [iam\_service\_accounts](#input\_iam\_service\_accounts) | A list of service accounts and their IAM roles. | <pre>list(object({<br>    id                          = string<br>    service_account_description = string<br>    roles                       = list(string)<br>    project_id                  = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_iam_service_agents"></a> [iam\_service\_agents](#input\_iam\_service\_agents) | A list of service agents and their IAM roles. | <pre>list(object({<br>    id             = string<br>    service        = string<br>    roles          = list(string)<br>    project_number = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_is_authoritative"></a> [is\_authoritative](#input\_is\_authoritative) | Indicates whether the IAM policies should be authoritative. Defaults to true. | `bool` | `true` | no |
| <a name="input_project"></a> [project](#input\_project) | The project object containing the project ID and project number. | <pre>object({<br>    project_id     = string<br>    project_number = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam"></a> [iam](#output\_iam) | The IAM members and their roles grouped by id |
<!-- END_TF_DOCS -->