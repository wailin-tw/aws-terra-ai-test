# CI/CD Pipeline Examples

Copy-ready Terraform CI/CD examples for common platforms.

These examples follow this handbook baseline:

1. `terraform fmt -check`
2. `terraform init`
3. `terraform validate`
4. `terraform plan` with artifact retention
5. `terraform apply` only after approval

---

## Assumptions

- Terraform root module path: `stacks/<stack-name>`
- Variable file path: `env/<environment>/<stack-name>.tfvars`
- Terraform version: 1.9+
- Production apply requires manual approval

---

## Provider-Specific Auth Variants

Prefer workload identity federation or OIDC over long-lived static secrets.

### AWS (GitHub Actions OIDC)

Add this before Terraform commands:

```yaml
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::<account-id>:role/<github-oidc-role>
    aws-region: eu-west-1
```

Terraform provider example:

```hcl
provider "aws" {
  region = var.aws_region
}
```

Notes:
- Trust policy should restrict `sub` to the exact repo and branch/environment.
- Use separate roles per environment (dev, staging, prod).

### Azure (GitHub Actions Federated Credential)

Add this before Terraform commands:

```yaml
- name: Azure login
  uses: azure/login@v2
  with:
    client-id: ${{ secrets.AZURE_CLIENT_ID }}
    tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

Terraform provider example:

```hcl
provider "azurerm" {
  features {}
}
```

Notes:
- Use Entra workload identity federation, not client secret credentials.
- Scope role assignments to resource group whenever possible.

### GCP (GitHub Actions Workload Identity Federation)

Add this before Terraform commands:

```yaml
- name: Authenticate to Google Cloud
  uses: google-github-actions/auth@v2
  with:
    workload_identity_provider: projects/<project-number>/locations/global/workloadIdentityPools/<pool>/providers/<provider>
    service_account: <sa-name>@<project-id>.iam.gserviceaccount.com

- name: Setup gcloud
  uses: google-github-actions/setup-gcloud@v2
```

Terraform provider example:

```hcl
provider "google" {
  project = var.project_id
  region  = var.region
}
```

Notes:
- Avoid service-account key files in CI.
- Grant least-privilege IAM roles to the federated service account.

### OCI (GitHub Actions with API Key Secret Material)

OCI federation support varies by workflow; if workload identity is not available, use short-lived key rotation and protected secrets.

Add this before Terraform commands:

```yaml
- name: Write OCI CLI config and key
  run: |
    mkdir -p ~/.oci
    cat > ~/.oci/config <<'EOF'
    [DEFAULT]
    user=${{ secrets.OCI_USER_OCID }}
    fingerprint=${{ secrets.OCI_FINGERPRINT }}
    tenancy=${{ secrets.OCI_TENANCY_OCID }}
    region=${{ secrets.OCI_REGION }}
    key_file=/home/runner/.oci/oci_api_key.pem
    EOF
    echo "${{ secrets.OCI_API_PRIVATE_KEY_PEM }}" > ~/.oci/oci_api_key.pem
    chmod 600 ~/.oci/oci_api_key.pem
```

Terraform provider example:

```hcl
provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  region       = var.region
}
```

Notes:
- Prefer instance/resource principal when running inside OCI.
- Rotate API keys regularly and scope secrets to protected environments.

### GitLab and Azure DevOps equivalents

- GitLab CI: use OpenID Connect (`CI_JOB_JWT`) for AWS/GCP/Azure federation where supported.
- Azure DevOps: use service connections with federated credentials where available.
- OCI on GitLab/Azure DevOps: store OCI key material in protected variable groups and rotate frequently.

---

## GitHub Actions

File: `.github/workflows/terraform.yml`

```yaml
name: terraform

on:
  pull_request:
    paths:
      - "stacks/**"
      - "modules/**"
      - "env/**"
  push:
    branches: ["main"]
    paths:
      - "stacks/**"
      - "modules/**"
      - "env/**"

env:
  TF_IN_AUTOMATION: true
  STACK_NAME: app-platform
  ENV_NAME: dev

jobs:
  plan:
    if: github.event_name == 'pull_request'
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
      pull-requests: write
    defaults:
      run:
        working-directory: stacks/${{ env.STACK_NAME }}
    steps:
      - uses: actions/checkout@v4

      - name: Setup Terraform
      uses: hashicorp/setup-terraform@v3
      with:
        terraform_version: 1.9.8

      - name: Terraform fmt
      run: terraform fmt -check -recursive

      - name: Terraform init
      run: terraform init -input=false

      - name: Terraform validate
      run: terraform validate

      - name: Terraform plan
      run: |
        terraform plan \
          -input=false \
          -out=tfplan \
          -var-file=../../env/${ENV_NAME}/${STACK_NAME}.tfvars

      - name: Upload plan artifact
      uses: actions/upload-artifact@v4
      with:
        name: tfplan-${{ env.STACK_NAME }}-${{ env.ENV_NAME }}
        path: stacks/${{ env.STACK_NAME }}/tfplan

  apply:
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment: production
    permissions:
      id-token: write
      contents: read
    defaults:
      run:
        working-directory: stacks/${{ env.STACK_NAME }}
    steps:
      - uses: actions/checkout@v4

      - name: Setup Terraform
      uses: hashicorp/setup-terraform@v3
      with:
        terraform_version: 1.9.8

      - name: Terraform init
      run: terraform init -input=false

      - name: Terraform apply
      run: |
        terraform apply -input=false -auto-approve \
          -var-file=../../env/${ENV_NAME}/${STACK_NAME}.tfvars
```

Notes:
- Use OIDC federation for cloud auth where possible.
- Use environment protection rules for production approvals.
- Add policy and security checks before plan when required.

---

## GitLab CI

File: `.gitlab-ci.yml`

```yaml
stages:
  - validate
  - plan
  - apply

variables:
  TF_IN_AUTOMATION: "true"
  TF_ROOT: "stacks/app-platform"
  ENV_NAME: "dev"
  STACK_NAME: "app-platform"

default:
  image: hashicorp/terraform:1.9.8
  before_script:
    - cd "$TF_ROOT"

fmt:
  stage: validate
  script:
    - terraform fmt -check -recursive

validate:
  stage: validate
  script:
    - terraform init -input=false
    - terraform validate

plan:
  stage: plan
  script:
    - terraform init -input=false
    - terraform plan -input=false -out=tfplan -var-file=../../env/${ENV_NAME}/${STACK_NAME}.tfvars
  artifacts:
    paths:
      - ${TF_ROOT}/tfplan
    expire_in: 7 days
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"

apply:
  stage: apply
  script:
    - terraform init -input=false
    - terraform apply -input=false -auto-approve -var-file=../../env/${ENV_NAME}/${STACK_NAME}.tfvars
  when: manual
  only:
    - main
```

Notes:
- Keep `apply` as manual for protected branches.
- Scope cloud credentials to protected environments only.

---

## Azure DevOps Pipelines

File: `azure-pipelines.yml`

```yaml
trigger:
  branches:
    include:
      - main
  paths:
    include:
      - stacks/*
      - modules/*
      - env/*

pr:
  branches:
    include:
      - main

variables:
  TF_VERSION: "1.9.8"
  TF_ROOT: "stacks/app-platform"
  ENV_NAME: "dev"
  STACK_NAME: "app-platform"

stages:
  - stage: ValidateAndPlan
    jobs:
      - job: terraform_plan
        pool:
          vmImage: "ubuntu-latest"
        steps:
          - checkout: self

          - task: TerraformInstaller@1
            inputs:
              terraformVersion: $(TF_VERSION)

          - script: terraform fmt -check -recursive
            displayName: Terraform fmt
            workingDirectory: $(TF_ROOT)

          - script: terraform init -input=false
            displayName: Terraform init
            workingDirectory: $(TF_ROOT)

          - script: terraform validate
            displayName: Terraform validate
            workingDirectory: $(TF_ROOT)

          - script: terraform plan -input=false -out=tfplan -var-file=../../env/$(ENV_NAME)/$(STACK_NAME).tfvars
            displayName: Terraform plan
            workingDirectory: $(TF_ROOT)

          - publish: $(TF_ROOT)/tfplan
            artifact: tfplan

  - stage: Apply
    dependsOn: ValidateAndPlan
    condition: and(succeeded(), eq(variables['Build.SourceBranch'], 'refs/heads/main'))
    jobs:
      - deployment: terraform_apply
        environment: production
        strategy:
          runOnce:
            deploy:
              steps:
                - checkout: self

                - task: TerraformInstaller@1
                  inputs:
                    terraformVersion: $(TF_VERSION)

                - script: terraform init -input=false
                  displayName: Terraform init
                  workingDirectory: $(TF_ROOT)

                - script: terraform apply -input=false -auto-approve -var-file=../../env/$(ENV_NAME)/$(STACK_NAME).tfvars
                  displayName: Terraform apply
                  workingDirectory: $(TF_ROOT)
```

Notes:
- Use environment approvals on the `production` environment.
- Keep service connections least-privilege and environment-scoped.

---

## Optional Security and Policy Stage

Add this between validate and plan:

```bash
tfsec .
checkov -d .
```

For policy enforcement examples, integrate OPA/Conftest or Sentinel rules in the same stage.

---

## Drift Detection (Scheduled)

Recommended schedule: daily for production stacks.

Typical command:

```bash
terraform plan -detailed-exitcode -var-file=../../env/prod/<stack-name>.tfvars
```

Interpretation:
- Exit code 0: no drift
- Exit code 2: drift detected
- Exit code 1: command error
