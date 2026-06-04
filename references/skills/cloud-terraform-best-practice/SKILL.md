---
name: cloud-terraform-best-practice
description: "Apply and audit best practices for Terraform infrastructure across AWS, Azure, GCP, and OCI. Use when: writing new Terraform resources, reviewing existing Terraform code, checking for Well-Architected compliance, auditing IAM permissions, validating tagging strategy, verifying state configuration, checking encryption, reviewing naming conventions, validating module structure, or preparing Terraform code for production."
argument-hint: "Describe the target (e.g. 'AWS VPC module', 'Azure AKS stack', 'GCP Cloud SQL resource', 'OCI VCN stack')"
---

# Cloud Terraform Best Practice

## When to Use

- You are writing new Terraform resources for any cloud provider.
- You are reviewing existing Terraform code before a plan or apply.
- You want a checklist of what good looks like before opening a PR.
- You are setting up a new stack or module and want to get the structure right from the start.

---

## Procedure

### Step 1 — Identify scope

Determine:

1. Which cloud provider is the target? (AWS / Azure / GCP / OCI / multi-cloud)
2. Is this a new module, a new stack, or a review of existing code?
3. What environment will this deploy to? (dev / staging / prod)
4. What is the data classification? (internal / confidential / public)

Load the relevant provider reference:

- AWS → [`./references/providers/aws.md`](./references/providers/aws.md)
- Azure → [`./references/providers/azure.md`](./references/providers/azure.md)
- GCP → [`./references/providers/gcp.md`](./references/providers/gcp.md)
- OCI → [`./references/providers/oci.md`](./references/providers/oci.md)

---

### Step 2 — Apply the cross-cloud baseline checklist

Work through each row. Mark ✅ pass, ⚠️ gap, or ❌ fail.

See [`./references/platform-standards.md`](./references/platform-standards.md) for the canonical list.

#### Identity and access

- [ ] Least privilege applied — no wildcard actions or overly broad roles.
- [ ] Short-lived credentials or managed identity used over long-lived API keys.
- [ ] IAM scope is limited to the minimum required resource or resource group.

#### Networking

- [ ] Resources are private by default — public exposure is explicit and justified.
- [ ] Network segmentation is in place (separate subnets or VPCs per environment).
- [ ] Ingress and egress rules are defined narrowly.

#### Secrets

- [ ] No plaintext secrets in variables, defaults, outputs, or state.
- [ ] Secrets are stored in the provider-managed secret service (Secrets Manager / Key Vault / Secret Manager / OCI Vault).
- [ ] Sensitive outputs are marked `sensitive = true`.

#### Encryption

- [ ] Data at rest is encrypted (storage, databases, volumes).
- [ ] Data in transit is encrypted (TLS enforced).
- [ ] Customer-managed keys (CMK) used where required by policy.

#### Tagging and labeling

- [ ] Every resource has: `owner`, `environment`, `cost-center`, `application`.
- [ ] Tags or labels are applied via variables — not hardcoded strings.

#### Observability

- [ ] Audit logging is enabled (CloudTrail / Activity Log / Cloud Audit Logs / OCI Audit).
- [ ] Metrics and alerts exist or are scoped for this workload.
- [ ] Log retention meets policy.

#### Backups and reliability

- [ ] Backup policy is defined for all stateful resources.
- [ ] Multi-zone or multi-region is confirmed or explicitly deferred with a reason.
- [ ] Health checks are present on load-balanced resources.

---

### Step 3 — Apply provider-specific checklist

Run the checklist that matches the target provider.

#### AWS checklist

- [ ] IAM roles use `assume_role_policy` with appropriate trust relationship.
- [ ] No `*` in `Action` or `Resource` without an inline comment justifying it.
- [ ] VPC uses private subnets for workloads; public subnets only for load balancers or NAT.
- [ ] CloudWatch alarms defined for key metrics before release.
- [ ] KMS key attached to S3, RDS, EBS, and Secrets Manager resources.
- [ ] S3 buckets have: versioning, public access block, server-side encryption.

#### Azure checklist

- [ ] Managed identity used instead of client secret / service principal password.
- [ ] RBAC assignments scoped to resource group or resource — not subscription.
- [ ] Private Endpoints used for storage, databases, and key vaults in production.
- [ ] Diagnostic settings linked to Log Analytics Workspace for every resource.
- [ ] Key Vault used for all secrets; `azurerm_key_vault_secret` references used.
- [ ] `azurerm` provider version pinned to `~> 4.0` or later.

#### GCP checklist

- [ ] Service accounts use predefined roles — no primitive roles (Owner, Editor) without justification.
- [ ] Workload Identity used for GKE workloads instead of downloaded key files.
- [ ] Private Google Access enabled on subnets for private workloads.
- [ ] Cloud KMS key ring and crypto key attached to storage and database resources.
- [ ] Logging sinks and Cloud Monitoring alert policies defined.
- [ ] `google` provider version pinned to `~> 6.0` or later.

#### OCI checklist

- [ ] IAM policies are compartment-scoped — not tenancy-wide without justification.
- [ ] Instance Principal or Resource Principal used instead of API key where possible.
- [ ] Resources are placed in the correct compartment — not the root compartment.
- [ ] OCI Vault used for secrets and encryption keys.
- [ ] Fault Domains distributed for compute resources in each Availability Domain.
- [ ] Defined tags applied for cost tracking; `oracle/oci` provider pinned to `~> 6.0`.

---

### Step 4 — Apply Terraform structure checklist

See [`./references/terraform-structure.md`](./references/terraform-structure.md) for the full layout standard.

- [ ] `required_version` declared in root module.
- [ ] `required_providers` declared with pinned versions.
- [ ] Remote backend configured with state locking enabled.
- [ ] State isolated by stack and environment.
- [ ] Shared patterns extracted to `modules/` — no copy-paste resource blocks across stacks.
- [ ] Environment-specific values live in `env/<environment>/*.tfvars` — not hardcoded in `.tf` files.
- [ ] Sensitive outputs marked `sensitive = true`.
- [ ] Module inputs are typed and described.
- [ ] New modules include a `README.md` with inputs table and example usage.
- [ ] `terraform fmt -check -recursive` passes.
- [ ] `terraform validate` passes.

---

### Step 5 — CI/CD pipeline check

- [ ] Pipeline runs `fmt`, `init`, `validate`, `plan` before any apply.
- [ ] Plan output is saved and reviewed before apply (not auto-applied).
- [ ] Production apply requires explicit approval.
- [ ] No secrets passed as plain environment variables — use secret manager or CI secret store.

---

### Step 6 — Output the result

Produce a structured summary:

```
## Best Practice Audit — <target>

### Provider: <AWS / Azure / GCP / OCI>
### Environment: <dev / staging / prod>

### Cross-cloud baseline
✅ Pass: <list>
⚠️  Gap:  <list with recommended action>
❌ Fail:  <list with required action>

### Provider-specific
✅ Pass: <list>
⚠️  Gap:  <list>
❌ Fail:  <list>

### Terraform structure
✅ Pass: <list>
⚠️  Gap:  <list>
❌ Fail:  <list>

### Summary
- Blockers before apply: <count>
- Recommended improvements: <count>
- Next action: <what the engineer should do first>
```

---

## References

- [`./references/platform-standards.md`](./references/platform-standards.md) — cross-cloud baseline
- [`./references/terraform-structure.md`](./references/terraform-structure.md) — folder, state, and module conventions
- [`./references/providers/aws.md`](./references/providers/aws.md)
- [`./references/providers/azure.md`](./references/providers/azure.md)
- [`./references/providers/gcp.md`](./references/providers/gcp.md)
- [`./references/providers/oci.md`](./references/providers/oci.md)
