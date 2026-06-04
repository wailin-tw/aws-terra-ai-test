# GCP

GCP-specific guidance for infrastructure delivery.

---

## Core services

- IAM for identity and access control.
- Cloud Audit Logs for audit logging.
- Cloud Monitoring for logs, metrics, and alerts.
- Cloud KMS for key management.
- VPC for network segmentation and routing.

---

## Terraform expectations

- Use Google provider configuration through Terraform.
- Prefer reusable modules for networks, IAM bindings, compute, and storage patterns.
- Use GCS backend (`backend "gcs"`) for Terraform state.

### Backend template snippet

```hcl
terraform {
	backend "gcs" {
		bucket = "<state-bucket>"
		prefix = "<org>/<project>/<stack>/<environment>"
	}
}
```

---

## Best practices

- Use least privilege on service accounts and bindings.
- Keep workloads private unless public exposure is required.
- Treat logging sinks, alert policies, and retention settings as mandatory platform concerns.
