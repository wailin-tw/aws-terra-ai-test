Terraform CI / Workflow for network-dev

Required GitHub repository configuration
- Secret: `AWS_ROLE_TO_ASSUME_DEV` — ARN of an IAM role configured for GitHub OIDC trust (recommended).
- GitHub Environment: `dev` — configure protections (required reviewers, wait timers) if desired.

How the workflow works
- Plan: runs on `pull_request` and `push` for changes under `infra/**`. It uploads a plan artifact named `network-dev-tfplan`.
- Apply: gated to manual `workflow_dispatch` and runs only when `run_apply` is set to `true`. The job downloads the saved artifact and applies it.

How to run (CI)
1. Open the workflow in GitHub Actions and click "Run workflow" for `Terraform Network Dev`.
2. Choose `run_apply=true` to execute the `apply` job (ensure `dev` environment protections and secrets are in place).
3. Confirm the run and monitor logs. The plan artifact is downloaded and applied.

Inspecting plan artifact
- After a `plan` run, download the `network-dev-tfplan` artifact from the Actions run and inspect it locally with:

```bash
terraform show -no-color network-dev-tfplan
``` 

Local workflow (developer)
```bash
cd infra/stacks/network-dev
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -var-file=../../env/dev/network-dev.tfvars -out=tfplan -input=false
terraform show -no-color tfplan
terraform apply -input=false tfplan
```

Notes and troubleshooting
- Ensure the stack's backend is configured (S3 + DynamoDB for locking) and the IAM role has permissions for state access.
- If you cannot use OIDC, you may supply `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as repository secrets (less recommended).
