---
name: terraform-module-generator
description: "Generate a reusable Terraform module scaffold with all required files, structure, documentation, and examples. Use when: creating a new module in modules/, scaffolding a resource pattern for reuse across stacks, setting up modules for VPC, IAM, compute, storage, database, or networking patterns, or preparing a module for team-wide use."
argument-hint: "Describe the module to create (e.g. 'AWS VPC module', 'Azure AKS module', 'GCP Cloud SQL module', 'OCI VCN module')"
---

# Terraform Module Generator

## When to Use

- You are creating a new reusable module in `modules/`.
- You want a consistent module structure across your team.
- You need boilerplate that follows the handbook conventions.
- You want example usage and documentation ready before team review.

---

## Procedure

### Step 1 — Describe the module

Provide:

1. **Module name** (e.g. `network`, `iam-role`, `rds-postgres`).
2. **Cloud provider** (AWS / Azure / GCP / OCI).
3. **Purpose** (e.g. "reusable VPC with public and private subnets").
4. **Inputs** (what should the caller be able to configure?).
5. **Outputs** (what should the module return?).

---

### Step 2 — Generate scaffold

The skill will create:

```
modules/<module-name>/
├── main.tf           # Resource definitions
├── variables.tf      # Typed inputs with descriptions
├── outputs.tf        # Module outputs
├── versions.tf       # Provider version pins
└── README.md         # Purpose, inputs table, outputs table, example usage
```

**File contents:**

#### `versions.tf`

```hcl
terraform {
  required_version = ">= 1.9"
  required_providers {
    <provider-name> = {
      source  = "<source>"
      version = "<pinned-version>"
    }
  }
}
```

For AWS: `source = "hashicorp/aws"`, `version = "~> 5.0"`
For Azure: `source = "hashicorp/azurerm"`, `version = "~> 4.0"`
For GCP: `source = "hashicorp/google"`, `version = "~> 6.0"`
For OCI: `source = "oracle/oci"`, `version = "~> 6.0"`

#### `variables.tf`

```hcl
variable "environment" {
  type        = string
  description = "Environment name (dev / staging / prod)"
}

variable "owner" {
  type        = string
  description = "Resource owner for tagging"
}

variable "cost_center" {
  type        = string
  description = "Cost center for billing allocation"
}

variable "application" {
  type        = string
  description = "Application name for tagging"
}

# Module-specific inputs here
```

#### `main.tf`

Resource definitions using `var.environment`, `var.owner`, `var.cost_center`, and `var.application` for tagging.

#### `outputs.tf`

```hcl
output "id" {
  value       = <resource-id>
  description = "Resource ID"
}

output "arn" {
  value       = <resource-arn>
  description = "Resource ARN"
  sensitive   = false
}

# Add sensitive = true for any output containing secrets or sensitive data
```

#### `README.md`

```markdown
# <Module Name> Module

## Purpose
<One sentence description>

## Inputs

| Name | Type | Description | Required |
|------|------|-------------|----------|
| environment | string | Environment name | Yes |
| owner | string | Resource owner | Yes |
| cost_center | string | Cost center | Yes |
| application | string | Application name | Yes |

## Outputs

| Name | Type | Description |
|------|------|-------------|
| id | string | Resource ID |

## Example Usage

\`\`\`hcl
module "<module-name>" {
  source = "../../modules/<module-name>"

  environment  = var.environment
  owner        = var.owner
  cost_center  = var.cost_center
  application  = var.application
  
  # Module-specific variables here
}
\`\`\`
```

---

### Step 3 — Review and customize

The scaffold is ready for:

1. Adding module-specific variables and outputs.
2. Writing resource definitions in `main.tf`.
3. Adding example usage to `README.md`.
4. Testing with `terraform validate` and `terraform fmt`.

---

## What's Included

✅ Provider version pinning  
✅ Standard tagging inputs (`environment`, `owner`, `cost_center`, `application`)  
✅ Typed input variables with descriptions  
✅ Output structure with `sensitive` marking for secrets  
✅ README with inputs and outputs tables  
✅ Example usage block  
✅ Terraform 1.9+ compatible  

---

## Next Step

Run `terraform validate` on the module to confirm syntax, then add your resource-specific logic to `main.tf`.
