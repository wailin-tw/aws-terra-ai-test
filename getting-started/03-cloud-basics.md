# Cloud Basics

This section defines the shared baseline for cloud projects using AWS, Azure, GCP, or OCI.

---

## Baseline expectations

| Area | Standard |
|---|---|
| Identity | Centralized identity, RBAC, least privilege, MFA, short-lived access |
| Networking | Segmented environments, private services where possible, controlled ingress and egress |
| Secrets | Managed secret storage, no plaintext secrets in code or pipelines |
| Compute | Immutable or declarative deployments, autoscaling where it helps |
| Data | Encryption, backups, retention policy, restore testing |
| Observability | Metrics, logs, traces, dashboards, alerts, ownership |
| Security | Policy-as-code, vulnerability checks, audit trails |
| Delivery | CI/CD pipelines with promotion and rollback |
| Cost | Tags, budgets, anomaly alerts, cleanup of unused assets |

---

## Cloud provider guidance

### AWS

Use IAM, CloudTrail, CloudWatch, KMS, and VPC as the main control plane building blocks.

### Azure

Use Entra ID, Activity Log, Monitor, Key Vault, and Virtual Networks as the main control plane building blocks.

### GCP

Use IAM, Cloud Audit Logs, Cloud Monitoring, Cloud KMS, and VPC as the main control plane building blocks.

### OCI

Use IAM, Audit, Monitoring, Vault, and Virtual Cloud Network (VCN) as the main control plane building blocks.

---

## Minimum platform artifacts

- Network layout and environment boundaries.
- Identity and access model.
- Secret and key management approach.
- Logging, monitoring, and alerting baseline.
- Terraform module structure and state strategy.
- Backup and restore policy.
- Cost tagging and budget policy.

---

## Next step

Continue to [**04-iac**](../04-iac.md) to see how changes should be delivered.
