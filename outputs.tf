output "iam" {
  description = "The IAM information."
  value = tomap({
    for principal in distinct([for rc in local.transformed_account_roles : rc.account]) : principal => {
      project_id     = local.transformed_account_roles[0].project_id
      project_number = local.transformed_account_roles[0].project_number
      roles          = [for rc in local.transformed_account_roles : rc.role if rc.account == principal]
      email          = [for rc in local.transformed_account_roles : rc.email if rc.account == principal][0]
    }
  })
}
