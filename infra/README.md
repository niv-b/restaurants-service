# Infra

The infra is provisioned with terraform, 
When you first run it locally, make sure to run the `infra/boostrap.sh` script that will login to azure and create the tf state blob storage.

Then you can run in each app, based on the order:

`terraform init`

`terraform plan -var-file=../environments/dev/github-azure-integration`

`terraform apply -var-file=../environments/dev/github-azure-integration`


## File Structure

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

`init -> plan -> apply`

Plan -> `terraform plan -var-file=../enviroments/$ENV/$APP/env.auto.tfvars`
