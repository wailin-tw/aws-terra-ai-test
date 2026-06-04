---
description: "Use when creating, modifying, or reviewing Terraform files for infrastructure stacks, modules, state design, security controls, and multi-cloud provider standards."
name: terraform
applyTo: "**/*.{tf,tfvars}"
---

# Terraform Instructions

## Scope

These rules apply to Terraform infrastructure work across AWS, Azure, GCP, and OCI.

## Required engineering workflow

1. Treat infrastructure as code. Do not rely on ad hoc console-first changes.
2. Require this validation sequence before merge: terraform fmt -check, terraform init, terraform validate, terraform plan.
3. Require explicit approval before production apply.
4. Keep and review plan artifacts before apply.

## Terraform structure rules

- Use remote backend state only.
- Backend policy by provider:
	- AWS must use `backend "s3"` with `use_lockfile = true`.
	- Azure should use `backend "azurerm"`.
	- GCP should use `backend "gcs"`.
	- OCI should use OCI Object Storage via S3-compatible backend.
- Isolate state by stack and environment.
- Enable state locking.
- Pin Terraform and provider versions.
- Keep reusable logic in modules and keep root stacks bounded by ownership.
- Keep environment values in env/<environment>/*.tfvars.
- Mark sensitive outputs with sensitive = true.

## Security rules

- Enforce least privilege in IAM or RBAC.
- Do not keep plaintext secrets in code, variables, defaults, outputs, or pipeline logs.
- Use cloud-native secret managers and key services.
- Keep services private by default; public access must be explicit and justified.

## Reliability and operations rules

- Require backup and restore strategy for stateful resources.
- Require health checks for load-balanced workloads.
- Require baseline observability: logs, metrics, alerts, and ownership.
- Require rollback readiness for risky infrastructure changes.

## Cost and governance rules

- Require tagging or labeling on every resource: owner, environment, cost-center, application.
- Include cost checks in code review: rightsizing, lifecycle policies, idle resource cleanup.
- Keep provider-specific exceptions documented and justified.

## Review checklist

- Plan output scope matches the intended change.
- No destructive actions without explicit approval.
- Backend choice follows provider policy, including AWS `use_lockfile = true`.
- Security, reliability, and cost controls are present.
- Provider-specific guidance is followed for the target cloud.
