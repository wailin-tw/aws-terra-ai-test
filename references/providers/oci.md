# OCI

Oracle Cloud Infrastructure-specific guidance for infrastructure delivery.

---

## Core services

- IAM for identity and access control.
- Audit for platform audit logging.
- Monitoring for logs, metrics, and alerts.
- Vault for key management.
- Virtual Cloud Network (VCN) for network segmentation and routing.

---

## Terraform expectations

- Use the OCI provider configuration through Terraform.
- Prefer reusable modules for compartments, networks, IAM policies, compute, and storage patterns.
- Use OCI Object Storage backend via S3-compatible configuration for Terraform state.

### Backend template snippet

```hcl
terraform {
	backend "s3" {
		endpoint                    = "https://<namespace>.compat.objectstorage.<region>.oraclecloud.com"
		bucket                      = "<state-bucket>"
		key                         = "<org>/<project>/<stack>/<environment>/terraform.tfstate"
		region                      = "<region>"
		skip_region_validation      = true
		skip_credentials_validation = true
		skip_metadata_api_check     = true
		force_path_style            = true
	}
}
```

---

## Best practices

- Use compartments to isolate environments and ownership.
- Keep public exposure explicit and minimal.
- Treat audit, monitoring, and tagging as part of the baseline platform setup.
