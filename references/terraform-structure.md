# Terraform Structure

Terraform is the standard Infrastructure as Code tool for infrastructure projects in this handbook.

---

## Goals

- Keep environment promotion predictable.
- Minimize copy-paste across providers and workloads.
- Keep state isolated and secure.
- Make reviews simple by keeping plans scoped and readable.

---

## Recommended repository layout

```text
infra/
├── modules/                         # Reusable modules shared by many stacks
│   ├── network/
│   ├── iam/
│   ├── compute/
│   └── observability/
├── stacks/                          # Root modules (deployable units)
│   ├── shared-services/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── providers.tf
│   └── app-platform/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── providers.tf
├── env/                             # Environment-specific input values
│   ├── dev/
│   │   ├── shared-services.tfvars
│   │   └── app-platform.tfvars
│   ├── staging/
│   └── prod/
├── policies/                        # Optional policy-as-code definitions
├── scripts/                         # Helper scripts (fmt/validate/plan wrappers)
└── README.md
```

---

## Design rules

### 1) Keep modules reusable and opinionated

- `modules/` contains shared building blocks.
- Do not place environment-specific values in modules.
- Keep module inputs explicit and typed.

### 2) Keep stacks small and bounded

- `stacks/` are root modules and should map to clear ownership boundaries.
- Avoid giant root modules that deploy everything.
- Split stacks when plan output becomes too large to review safely.

### 3) Keep environment values outside code

- Keep environment-specific values in `env/<environment>/*.tfvars`.
- Promote the same stack code across environments with different inputs.
- Sensitive values should come from secret managers or secure pipeline variables.

### 4) Keep provider configuration explicit

- Declare providers in each stack.
- Pin Terraform and provider versions intentionally.
- Use aliases only when there is a clear multi-region or multi-account need.

---

## State strategy

- Use remote backends only.
- Backend policy by provider:
  - AWS: `backend "s3"` with `use_lockfile = true`.
  - Azure: `backend "azurerm"`.
  - GCP: `backend "gcs"`.
  - OCI: S3-compatible backend for OCI Object Storage.
- Isolate state by stack and environment.
- Enable locking where backend supports it.
- Restrict backend access to deployment identities.
- Encrypt state at rest and in transit.

Example state key convention:

```text
<org>/<project>/<stack>/<environment>/terraform.tfstate
```

---

## Naming and tagging

- Resource names should include environment and workload context.
- Apply required tags/labels consistently: owner, environment, cost-center, application, data-classification.
- Enforce naming and tagging via module validation where possible.

---

## CI/CD workflow

Minimum Terraform pipeline stages:

1. `terraform fmt -check`
2. `terraform init`
3. `terraform validate`
4. `terraform plan` (artifact saved and reviewed)
5. `terraform apply` (approved environments only)

Additional recommended checks:

- Security scanning of Terraform code.
- Policy checks before apply.
- Drift detection on a schedule.

See [ci-cd-pipeline-examples.md](./ci-cd-pipeline-examples.md) for copy-ready pipeline templates.

---

## Environment promotion model

- Merge to main after plan review for dev.
- Promote the same stack commit to staging.
- Promote the same stack commit to production with explicit approval.
- Avoid changing both code and environment inputs at the same promotion step unless required.

---

## Multi-cloud notes

- Keep provider-specific logic in stack composition, not in generic modules unless necessary.
- Prefer a common module interface for shared patterns (networking, IAM-like role mapping, observability hooks).
- Document provider exceptions in:
  - [provider-guidance.md](./provider-guidance.md)
  - [providers/aws.md](./providers/aws.md)
  - [providers/azure.md](./providers/azure.md)
  - [providers/gcp.md](./providers/gcp.md)
  - [providers/oci.md](./providers/oci.md)

---

## Anti-patterns to avoid

- One state file for all environments.
- Manual console changes without reconciliation.
- Unpinned provider versions.
- Oversized root modules with mixed ownership.
- Long-lived feature branches for infrastructure changes.
