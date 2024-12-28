# Infra

The infra is provisioned with terraform, please use GitHub Actions with:
`.github/workflows/terraform-plan.yaml` in order to check changed configurations
and `.github/workflows/terraform-apply.yaml` to change configurations.

## File Structure

The folder consists the `configs` folder for changing config files
`Templates` is terraform templates
`Regions` is per environment values.

```text
.
├── README.md
├── modules
├── environments
│   └── dev
│       ├── template
│       │   └── env.auto.tfvars
└── app
    ├── main.tf
    ├── provider.tf
    └── vars.tf
```

## Terraform Lifecycle

`init -> workspace -> plan -> apply`

1. Init -> `terraform init`

3. Plan -> `terraform plan -var-file=../enviroments/$ENV/$APP/env.auto.tfvars`
