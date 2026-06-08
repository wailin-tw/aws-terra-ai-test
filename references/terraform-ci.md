Terraform CI / Workflow for network-dev

Required GitHub repository configuration
- Secret: `AWS_ROLE_TO_ASSUME_DEV` — ARN of an IAM role configured for GitHub OIDC trust (recommended) for the dev stack.
- Secret: `AWS_ROLE_TO_ASSUME_PROD` — ARN of an IAM role configured for GitHub OIDC trust (recommended) for the prod stack.
- GitHub Environments: `dev` and `prod` — configure protections (required reviewers, wait timers) if desired.

How the workflow works
- Plan: runs on `pull_request` and `push` for changes under `infra/**`. It uploads a plan artifact named `network-dev-tfplan` (for dev) or `network-prod-tfplan` (for prod).
- Apply: gated to manual `workflow_dispatch` and runs when `run_apply` is set to `true`, or auto-applies on pushes to `main` (see branch rules). The job downloads the saved artifact and applies it.

How to run (CI)
Dev (PRs and branch testing)
1. Open the workflow in GitHub Actions and click "Run workflow" for `Terraform Network Dev`.
2. Choose the branch/ref and set `run_apply` to `true` to run both `plan` and `apply` in the same run; or run with `run_apply=false` to only plan.
3. Confirm the run and monitor logs. The plan artifact is downloaded and applied when requested.

Prod (staged deploys)
1. Open the workflow in GitHub Actions and click "Run workflow" for `Terraform Network Prod`.
2. Choose the branch/ref and set `run_apply` to `true` to run both `plan` and `apply` in the same run; or run with `run_apply=false` to only plan.
3. For safety, `apply` auto-runs on pushes to `main` (make sure `prod` environment protections are configured).

Inspecting plan artifact
- After a `plan` run, download the `network-dev-tfplan` artifact from the Actions run and inspect it locally with:

```bash
terraform show -no-color network-dev-tfplan
``` 

Local workflow (developer)
Dev example
```bash
cd infra/stacks/network-dev
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -var-file=../../env/dev/network-dev.tfvars -out=tfplan -input=false
terraform show -no-color tfplan
terraform apply -input=false tfplan
```

Prod example
```bash
cd infra/stacks/network-prod
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -var-file=../../env/prod/network-prod.tfvars -out=tfplan -input=false
terraform show -no-color tfplan
terraform apply -input=false tfplan
```

Notes and troubleshooting
- Ensure the stack's backend is configured (S3 + DynamoDB for locking) and the IAM role has permissions for state access.
- If you cannot use OIDC, you may supply `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` as repository secrets (less recommended).

Environment approvals and IAM
- The workflows rely on GitHub Environment protections for `dev` and `prod` to gate `apply` runs. Configure repository Settings → Environments → `dev` and `prod` and add required reviewers or wait timers to enforce approvals before apply.
- IAM: see `references/iam/trust-template.json` for an OIDC trust policy template and `references/iam/terraform-policy-example.json` for a Terraform permissions example. Replace placeholders (account id, bucket, region, lock table, role names) before applying.

Applying IAM changes (CLI)
1. Save `references/iam/trust-template.json` as `trust.json` and substitute `REPLACE_WITH_ACCOUNT_ID` and `REPLACE_WITH_OWNER/REPO`.
2. Update the role trust policy:

```bash
aws iam update-assume-role-policy --role-name YOUR_ROLE_NAME --policy-document file://trust.json
```

3. Create or attach the Terraform policy example (edit `terraform-policy-example.json` placeholders first):

```bash
aws iam create-policy --policy-name TerraformCI-Example --policy-document file://references/iam/terraform-policy-example.json
```

Notes
- For production, tighten resource ARNs and limit `iam:PassRole` to specific roles only. The example policy is intentionally broad in places to be a starting point.
- Use GitHub Environments to require human approval on `apply` for `prod`.
