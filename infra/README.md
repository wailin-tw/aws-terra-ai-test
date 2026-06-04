# Terraform Infra

This folder contains reusable Terraform modules and root stacks.

## Create AWS dev VPC

1. Edit stack and env files:
   - `stacks/network-dev/backend.tf`
   - `env/dev/network-dev.tfvars`
2. Authenticate to AWS (SSO or assumed role).
3. Run:

```bash
cd infra/stacks/network-dev
terraform fmt -check
terraform init
terraform validate
terraform plan -var-file=../../env/dev/network-dev.tfvars
```

Apply after review and approval:

```bash
terraform apply -var-file=../../env/dev/network-dev.tfvars
```

## GitHub Actions

Workflow file: `.github/workflows/terraform-network-dev.yml`

- Runs fmt, backend policy checks, init, validate, and plan for the dev network stack.
- Uploads the `tfplan` artifact.
- Supports manual apply from the exact saved plan artifact via `workflow_dispatch`.