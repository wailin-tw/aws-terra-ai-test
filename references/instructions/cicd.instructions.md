---
description: "Use when creating, modifying, or reviewing CI/CD workflows for Terraform pipelines, promotion gates, environment approvals, credential federation, policy checks, and drift detection."
name: cicd
applyTo:
  - ".github/workflows/**/*.yml"
  - ".github/workflows/**/*.yaml"
  - ".gitlab-ci.yml"
  - "azure-pipelines.yml"
---

# CI/CD Instructions

## Scope

These rules apply to Terraform delivery pipelines across GitHub Actions, GitLab CI, and Azure DevOps.

## Required pipeline stages

Every infrastructure pipeline must include:

1. terraform fmt -check
2. terraform init
3. terraform validate
4. terraform plan with saved artifact
5. approved terraform apply

Apply integrity requirement:

- Apply must use the reviewed plan artifact or the exact same commit and variables used for plan.

## Approval and promotion rules

- Keep apply on protected branches and protected environments only.
- Require explicit approval for production apply.
- Promote the same commit from dev to staging to production.
- Avoid mixing large code changes and environment variable changes in the same promotion step.

## Credential and access rules

- Prefer OIDC or workload identity federation over long-lived static secrets.
- Scope pipeline identity permissions to least privilege and environment boundaries.
- Separate identities per environment where possible.
- Never print secrets in pipeline logs.

## Backend policy checks

- AWS pipelines must validate Terraform backend is `s3` with `use_lockfile = true`.
- Azure pipelines should validate Terraform backend is `azurerm`.
- GCP pipelines should validate Terraform backend is `gcs`.
- OCI pipelines should validate OCI-related backend configuration is used.
- Fail pipeline review if backend policy does not match the target provider.

## Quality and security gates

- Fail pipeline on formatting or validation errors.
- Add policy and security checks before plan or before apply when required.
- Keep plan artifacts for review and traceability.
- Run scheduled drift detection for production stacks.

## Operational rules

- Ensure rollback path is documented for risky infrastructure changes.
- Record pipeline ownership and on-call contact.
- Keep retry behavior controlled; avoid repeated failing applies.
- Keep branch and path filters scoped so infra pipelines run only when relevant files change.

## Review checklist

- Pipeline includes all required Terraform stages.
- Production apply requires explicit approval.
- Authentication uses federation or tightly scoped credentials.
- Backend policy matches provider (AWS S3 + `use_lockfile = true`; Azure `azurerm`; GCP `gcs`; OCI related backend).
- Plan artifact retention and drift checks are configured.
- Apply uses approved plan artifact or identical commit and variables.
