# Infrastructure as Code

Terraform is the standard Infrastructure as Code tool for this handbook.

Infrastructure should be delivered as code, not by ad hoc console changes.

For the recommended repository layout and environment strategy, see [../references/terraform-structure.md](../references/terraform-structure.md).

---

## Rules of delivery

- Every meaningful infrastructure change goes through a pull request.
- The desired state should live in source control as Terraform code.
- Environments should be reproducible from code and configuration.
- Changes should be validated before apply.

---

## Recommended practices

| Practice | Expectation |
|---|---|
| Modules | Reuse standard Terraform modules for common platform patterns |
| Naming | Use predictable names for environments, resources, and accounts |
| State | Protect remote state, avoid manual drift, and review changes before apply |
| Promotion | Move Terraform changes through dev, staging, and production intentionally |
| Review | Include security, operations, and cost checks in Terraform plan review |

---

## Guardrails

- Do not apply a change directly in production unless the workflow explicitly allows it.
- Do not bypass `terraform plan` review unless the workflow explicitly allows it.
- Do not create secrets or sensitive values in plain text.
- Do not leave drift unresolved when infrastructure changes are coming from code.
- Do not skip rollback planning for risky changes.

---

## Next step

Continue to [**05-operations**](../05-operations.md) for day-2 operating practices.
