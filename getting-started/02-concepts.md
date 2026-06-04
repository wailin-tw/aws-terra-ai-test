# Concepts

The infrastructure handbook uses a small set of concepts to keep cloud delivery consistent across AWS, Azure, GCP, and OCI.

---

## The model

| Concept | What it is | Why it matters |
|---|---|---|
| `copilot-instructions.md` | Project-level entry file for AI tooling | It defines which modules, policies, and references are active |
| `references/` | Reusable standards and guidance | It contains the material that gets copied or linked into projects |
| `runbooks/` | Step-by-step operational procedures | It turns incident handling and maintenance into repeatable actions |
| `decisions/` | Architecture and platform decisions | It preserves the rationale behind platform choices |
| `getting-started/` | Human onboarding material | It explains the handbook before a project adopts it |

---

## DevOps principles

### Infrastructure as code

All meaningful platform changes should be expressed in code, reviewed in pull requests, and deployed through automation.

### Security by default

Use least privilege, short-lived credentials, managed secret stores, encrypted data, and audit logging from the start.

### Operability first

Every service needs a monitoring plan, an alerting plan, a rollback path, and a recovery path before release.

### Provider-aware, not provider-bound

Standardize the operating model across clouds, but allow AWS, Azure, GCP, or OCI native services when they clearly improve reliability or cost.

### Cost discipline

Tag resources, enforce budgets, and review idle or oversized assets on a regular schedule.

---

## Key dependencies

- `references/` should capture the shared platform baseline.
- `runbooks/` should capture how to respond when that baseline fails.
- `decisions/` should explain why the platform is built the way it is.

---

## Next step

Continue to [**03-cloud-basics**](../03-cloud-basics.md) for the platform baseline.
