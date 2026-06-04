# Introduction

Welcome to the Infrastructure department handbook. This guide explains how we design and operate cloud platforms across AWS, Azure, GCP, and Oracle Cloud Infrastructure (OCI).

The goal is simple: keep the platform secure, observable, reproducible, and cost-aware while making it easy for application teams to deploy safely.

---

## Who this is for

- **Platform and DevOps engineers** - daily reference for cloud standards and operating practices.
- **Cloud architects** - define cross-cloud patterns and provider-specific exceptions.
- **Application teams** - understand the platform baseline they deploy onto.
- **Security and operations** - review access, monitoring, incident handling, and cost controls.

---

## How to read this guide

| Step | What you'll learn |
|---|---|
| **01-introduction** (you are here) | What this handbook is, who it is for, and how the folders fit together |
| [**02-concepts**](02-concepts.md) | Core DevOps and cloud-platform ideas used in this handbook |
| [**03-cloud-basics**](03-cloud-basics.md) | Shared landing-zone, security, networking, and identity expectations |
| [**04-iac**](../04-iac.md) | How we use infrastructure as code and delivery automation |
| [**05-operations**](../05-operations.md) | Day-2 operations, observability, incident response, and cost control |

---

## Handbook goals

- Standardize cloud delivery across providers without forcing unnecessary duplication.
- Prefer managed services where they reduce operational burden.
- Use infrastructure as code for every material platform change.
- Make security, observability, and cost controls part of the default workflow.

---

## What good looks like

- Infrastructure changes are versioned, reviewed, and repeatable.
- Access is least-privilege and tied to real operational roles.
- Logs, metrics, traces, and alerts exist before the platform is handed off.
- Backups and restores are tested, not assumed.
- Cloud spend is tagged, visible, and reviewed regularly.

---

## Next step

Go to [**02-concepts**](02-concepts.md) to learn the building blocks of the handbook.
