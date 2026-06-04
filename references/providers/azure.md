# Azure

Azure-specific guidance for infrastructure delivery.

---

## Core services

- Entra ID for identity and access control.
- Activity Log for platform audit logging.
- Monitor for logs, metrics, and alerts.
- Key Vault for secrets and keys.
- Virtual Networks for network segmentation and routing.

---

## Terraform expectations

- Use Azure provider configuration through Terraform.
- Prefer reusable modules for networks, role assignments, compute, and storage patterns.
- Use Azure Storage backend (`backend "azurerm"`) for Terraform state.

### Backend template snippet

```hcl
terraform {
	backend "azurerm" {
		resource_group_name  = "<rg-name>"
		storage_account_name = "<storage-account>"
		container_name       = "<container>"
		key                  = "<org>/<project>/<stack>/<environment>/terraform.tfstate"
	}
}
```

---

## Best practices

- Use managed identity where possible.
- Keep network exposure explicit and limited.
- Treat alerts and diagnostic settings as part of the platform baseline.
