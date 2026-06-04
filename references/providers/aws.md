# AWS

AWS-specific guidance for infrastructure delivery.

---

## Core services

- IAM for identity and access control.
- CloudTrail for audit logging.
- CloudWatch for logs, metrics, and alarms.
- KMS for key management.
- VPC for network segmentation and routing.

---

## Terraform expectations

- Use AWS provider configuration through Terraform.
- Prefer reusable modules for VPCs, IAM roles, compute, and storage patterns.
- Use S3 backend for Terraform state with `use_lockfile = true`.

### Backend template snippet

```hcl
terraform {
	backend "s3" {
		bucket       = "<state-bucket>"
		key          = "<org>/<project>/<stack>/<environment>/terraform.tfstate"
		region       = "<region>"
		encrypt      = true
		use_lockfile = true
	}
}
```

---

## Best practices

- Use short-lived credentials and role assumption.
- Default to private subnets for workloads that do not need public access.
- Treat CloudWatch alarms as part of the release definition, not an afterthought.
