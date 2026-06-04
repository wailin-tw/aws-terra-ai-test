# Infrastructure Department

The Infrastructure department covers cloud platform delivery across AWS, Azure, GCP, and Oracle Cloud Infrastructure (OCI). This folder is the source of truth for how we design, provision, secure, observe, and operate infrastructure with clear best practices that work across providers.

If you are new here, start with this README first, then add provider-specific guidance only where the cloud service changes the implementation.

---

## Handbook map

| Section | Purpose |
|---|---|
| [getting-started/](./getting-started/) | Human onboarding and handbook overview |
| [references/](./references/) | Reusable standards, provider guidance, and AI entry points |
| [references/agents/](./references/agents/) | AI agents for infrastructure work |
| [references/instructions/](./references/instructions/) | Reusable instruction modules for DevOps workflows |
| [references/providers/](./references/providers/) | Provider-specific guidance (AWS, Azure, GCP, OCI) |
| [references/skills/](./references/skills/) | Reusable skills for infrastructure workflows |
| [runbooks/](./runbooks/) | Operational procedures for incidents, recovery, and cost reviews |
| [decisions/](./decisions/) | Architecture and platform decision records |

Key references:
- [Terraform structure](./references/terraform-structure.md)
- [CI/CD pipeline examples](./references/ci-cd-pipeline-examples.md)
- [Terraform instruction module](./references/instructions/terraform.instructions.md)
- [CI/CD instruction module](./references/instructions/cicd.instructions.md)
- [Provider guidance index](./references/provider-guidance.md)
- [Platform standards](./references/platform-standards.md)

Agents:
- [AWS Terraform agent](./references/agents/aws-terraform.agent.md) — `@aws-terraform`
- [Azure Terraform agent](./references/agents/azure-terraform.agent.md) — `@azure-terraform`
- [GCP Terraform agent](./references/agents/gcp-terraform.agent.md) — `@gcp-terraform`
- [OCI Terraform agent](./references/agents/oci-terraform.agent.md) — `@oci-terraform`
- [Terraform Review agent](./references/agents/terraform-review.agent.md) — `@terraform-review`

Skills:
- [cloud-terraform-best-practice](./references/skills/cloud-terraform-best-practice/SKILL.md) — `/cloud-terraform-best-practice`
- [terraform-module-generator](./references/skills/terraform-module-generator/SKILL.md) — `/terraform-module-generator`
- [cloud-cost-review](./references/skills/cloud-cost-review/SKILL.md) — `/cloud-cost-review`

---

## Who this is for

| Role | Usage |
|---|---|
| **Infrastructure engineers** | Daily reference for platform standards, landing zones, Terraform, and operational practices. |
| **Cloud architects** | Define cross-cloud patterns and decide when to standardize vs. specialize per provider. |
| **Application teams** | Understand the supported cloud baseline and the guardrails required before deployment. |
| **Security and operations** | Review access, compliance, monitoring, incident response, and cost controls. |

---

## Core principles

### Prefer cloud-agnostic design where it helps

Use a shared operating model for identity, networking, secrets, logging, policy, and deployment workflows. Accept provider-specific services only when they clearly improve reliability, security, or delivery speed.

### Build for security first

Default to least privilege, encrypted data at rest and in transit, strong identity boundaries, secret management, audit logging, and policy-as-code.

### Treat infrastructure as code

All meaningful infrastructure changes should be versioned, reviewed, tested, and reproducible through Terraform and automation.

### Optimize for operability

Every platform decision should consider observability, rollback, backup, recovery, scaling, and on-call support before release.

### Control cost intentionally

Use tagging, budgets, alerts, rightsizing, lifecycle policies, and scheduled cleanup so cost stays visible and explainable.

---

## Best-practice baseline

These standards apply across AWS, Azure, GCP, and OCI unless a project documents a justified exception.

| Area | Baseline |
|---|---|
| Identity | Centralized identity, least privilege, role-based access, short-lived credentials |
| Networking | Segmented environments, private-by-default services, controlled ingress and egress |
| Secrets | Managed secret storage, no plaintext secrets in code or CI logs |
| Compute | Immutable or declarative deployments, repeatable images, autoscaling where appropriate |
| Data | Encryption, backups, retention policy, tested restore procedures |
| Observability | Metrics, logs, traces, alerts, dashboard ownership |
| Security | Policy-as-code, vulnerability scanning, audit trails, change approval gates |
| Delivery | CI/CD pipelines with environment promotion, Terraform plan review, and rollback paths |
| Cost | Tags, budgets, anomaly alerts, and periodic review of underused resources |

---

## Cloud platform guidance

Provider-specific details live in [references/provider-guidance.md](./references/provider-guidance.md) and the files under [references/providers/](./references/providers/).

### AWS

Use AWS-native services when they align with the baseline: IAM, CloudTrail, CloudWatch, KMS, VPC, and managed compute or data services where they simplify operations. See [references/providers/aws.md](./references/providers/aws.md).

### Azure

Use Azure-native services consistently with the baseline: Entra ID, Activity Log, Monitor, Key Vault, Virtual Networks, and managed platform services where they reduce operational overhead. See [references/providers/azure.md](./references/providers/azure.md).

### GCP

Use GCP-native services consistently with the baseline: IAM, Cloud Audit Logs, Cloud Monitoring, Cloud KMS, VPC, and managed services that improve reliability and reduce manual maintenance. See [references/providers/gcp.md](./references/providers/gcp.md).

### Oracle Cloud Infrastructure (OCI)

Use OCI-native services consistently with the baseline: IAM, Audit, Monitoring, Vault, Virtual Cloud Network (VCN), and managed platform services where they reduce operational overhead. See [references/providers/oci.md](./references/providers/oci.md).

---

## Suggested folder structure

This folder is intentionally starting small. Grow it as the platform matures.

```text
departments/infra/
├── README.md          ← you are here
├── getting-started/   ← onboarding and platform overview
├── references/        ← reusable docs, templates, and standards
│   ├── agents/        ← AI agents for infrastructure work
│   └── providers/     ← provider-specific guidance
├── runbooks/          ← operational procedures
└── decisions/         ← architecture and platform decision records
```

---

## Working rule

When a new cloud capability is introduced, document the shared best practice first, then add provider-specific notes only if AWS, Azure, GCP, and OCI differ in a meaningful way.