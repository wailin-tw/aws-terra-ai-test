---
name: cloud-cost-review
description: "Audit Terraform infrastructure for cost risks and optimization opportunities across AWS, Azure, GCP, and OCI. Use when: reviewing cloud costs, identifying rightsizing opportunities, checking for unused resources, auditing instance types and SKUs, validating autoscaling strategy, checking storage lifecycle policies, reviewing reserved instance or savings plan coverage, or preparing for cost optimization."
argument-hint: "Provide the stack path or resource type to audit (e.g. 'stacks/app-platform', 'modules/compute', 'all AWS resources')"
---

# Cloud Cost Review

## When to Use

- You want to identify cost optimization opportunities in your infrastructure.
- You are preparing a cost optimization plan for your team.
- You want to verify that rightsizing and autoscaling are in place before production deployment.
- You are reviewing resource costs as part of a cost governance initiative.

---

## Procedure

### Step 1 — Identify scope

Determine:

1. **Target scope**: specific stack, specific resource type, or all resources?
2. **Cloud provider**: AWS / Azure / GCP / OCI / multi-cloud?
3. **Environment**: dev / staging / prod (cost review often differs by environment)?
4. **Expected baseline**: what is the target monthly cost or cost per resource?

---

### Step 2 — Apply provider-agnostic cost checklist

Work through each row. Mark ✅ optimized, ⚠️ review needed, or ❌ action required.

#### Compute sizing

- [ ] Instance types / SKUs are right-sized (not always maximum available size).
- [ ] Compute workloads use autoscaling — not always-on fixed capacity.
- [ ] Serverless or managed services used where they reduce operational overhead and cost (AWS Fargate, Azure Container Instances, GCP Cloud Run, OCI Container Instances).
- [ ] Development and non-production resources use smaller or burstable instance types.
- [ ] Reserved Instances (AWS), Savings Plans, or committed use discounts (Azure, GCP, OCI) are in use for stable workloads.

#### Storage and data transfer

- [ ] Storage lifecycle policies are defined (S3 Intelligent Tiering, Azure Cool Tier, GCP Nearline/Coldline, OCI Standard/Archive).
- [ ] Unused snapshots and volumes are identified and scheduled for deletion.
- [ ] Data transfer is minimized (VPN, Direct Connect, ExpressRoute, Dedicated Interconnect used for bulk transfer).
- [ ] Cross-region replication is only enabled where required.

#### Databases

- [ ] Database instance types are right-sized for the workload.
- [ ] Multi-AZ or read replicas are only enabled where needed (not in dev/test).
- [ ] Database backups are configured with appropriate retention (not 30 days if 7 days is sufficient).
- [ ] Database autoscaling is enabled where capacity varies.

#### Networking

- [ ] Load balancers are only active on stacks that need them.
- [ ] NAT Gateway usage is optimized (consolidate or use NAT instances where cost-appropriate).
- [ ] Direct Connect / ExpressRoute / Dedicated Interconnect is only used where cost-justified.
- [ ] VPN tunnels are only active where needed.

#### Monitoring and logging

- [ ] Log retention is set to the minimum required (not keeping logs for 5 years if 90 days is sufficient).
- [ ] Metric retention is appropriate (not storing every data point forever).
- [ ] Debug/verbose logging is disabled in production.

---

### Step 3 — Apply provider-specific cost review

#### AWS

- [ ] EC2 instances use latest generation types (`c7i`, `m7i`, `r7i` — not `t2`, `c5`, `m5`).
- [ ] RDS uses Graviton (`db.t4g`, `db.r7g`) where available.
- [ ] S3 uses `Intelligent-Tiering` for unpredictable access patterns, not always Standard.
- [ ] CloudFront is used for static asset distribution (not serving from EC2).
- [ ] EC2 Savings Plans or Reserved Instances cover 60%+ of compute spend for stable workloads.
- [ ] Unused Elastic IPs, EBS volumes, and snapshots are identified in Cost Explorer.

#### Azure

- [ ] VMs use appropriate tiers: Burstable (B-series) for dev, Standard (D-series) for production.
- [ ] Hybrid Benefit is applied if you have on-premises licenses.
- [ ] Blob storage uses Cool or Archive tier for infrequent access.
- [ ] Reserved Instances or Savings Plans cover 60%+ of compute spend.
- [ ] Unattached managed disks and unused public IPs are removed.
- [ ] Application Insights sampling is enabled to reduce logging costs.

#### GCP

- [ ] Compute Engine uses sustained-use discounts (automatically applied).
- [ ] Committed use discounts (1-year or 3-year) are in place for stable workloads.
- [ ] Cloud Storage uses Coldline or Archive for backup/archive data.
- [ ] Cloud SQL uses multi-zone only where high availability is required.
- [ ] BigQuery queries are optimized (clustering, partitioning, slot commitments for heavy users).
- [ ] Unused Cloud Functions and App Engine services are deleted.

#### OCI

- [ ] Compute shapes are right-sized (Flex, Standard, GPU — not always maximum cores).
- [ ] Capacity Reservations or Universal Credits are in use if applicable.
- [ ] Object Storage uses Standard tier; Archive tier for long-term backup.
- [ ] Autonomous Database uses appropriate compute / storage sizing.
- [ ] Unused compute instances and block volumes are identified and terminated.

---

### Step 4 — Tagging and cost allocation review

- [ ] Every resource has a `cost_center` or `cost-center` tag.
- [ ] Cost allocation tags are consistent across all resources.
- [ ] Cost anomaly alerts are configured in Cost Explorer / Cost Management / Billing or OCI Cost Analysis.
- [ ] Monthly cost reports are being generated and reviewed.

---

### Step 5 — Output the cost review report

```
## Cost Review — <target>

### Provider: <AWS / Azure / GCP / OCI>
### Environment: <dev / staging / prod>
### Estimated monthly impact of findings: $<number>

### Compute sizing
✅ Optimized: <list>
⚠️ Review needed: <list with estimated monthly savings>
❌ Action required: <list with required action and estimated savings>

### Storage and lifecycle
✅ Optimized: <list>
⚠️ Review needed: <list>
❌ Action required: <list>

### Databases
✅ Optimized: <list>
⚠️ Review needed: <list>
❌ Action required: <list>

### Networking
✅ Optimized: <list>
⚠️ Review needed: <list>
❌ Action required: <list>

### Monitoring and logging
✅ Optimized: <list>
⚠️ Review needed: <list>
❌ Action required: <list>

### Cost allocation and reporting
✅ Optimized: <list>
⚠️ Review needed: <list>
❌ Action required: <list>

### Summary
- Annual savings opportunity: $<number>
- High-priority actions: <count>
- Medium-priority optimizations: <count>
- Next step: <what the engineer should do first>
```

---

## References

- Handbook cost baseline: `departments/infra/references/platform-standards.md`
- AWS cost optimization: [AWS Cost Optimization Hub](https://aws.amazon.com/cost-management/)
- Azure cost optimization: [Azure Cost Management + Billing](https://learn.microsoft.com/en-us/azure/cost-management-billing/)
- GCP cost optimization: [Google Cloud Cost Management](https://cloud.google.com/cost-management)
- OCI cost optimization: [OCI Cost Analysis](https://www.oracle.com/cloud/price-list/)
