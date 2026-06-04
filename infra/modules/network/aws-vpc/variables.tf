variable "name_prefix" {
  description = "Short project or workload name used in resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name, for example dev, staging, or prod"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "Availability zones used for subnet placement"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "Provide at least 2 availability zones for baseline resilience."
  }
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks, one per availability zone"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.availability_zones)
    error_message = "public_subnet_cidrs must have one CIDR per availability zone."
  }
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR blocks, one per availability zone"
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) == length(var.availability_zones)
    error_message = "private_subnet_cidrs must have one CIDR per availability zone."
  }
}

variable "enable_nat_gateway" {
  description = "Whether to create a NAT gateway for outbound internet from private subnets"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags that must be applied to all resources"
  type        = map(string)
}