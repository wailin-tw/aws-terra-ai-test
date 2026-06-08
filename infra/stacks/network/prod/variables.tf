variable "aws_region" {
  description = "AWS region for the stack"
  type        = string
}

variable "project_name" {
  description = "Short project identifier used in naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "owner" {
  description = "Resource owner tag"
  type        = string
}

variable "cost_center" {
  description = "Cost center tag"
  type        = string
}

variable "application" {
  description = "Application tag"
  type        = string
}

variable "data_classification" {
  description = "Data classification tag"
  type        = string
  default     = "internal"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "availability_zones" {
  description = "Availability zones for subnet distribution"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR list"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDR list"
  type        = list(string)
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateway for private subnet egress"
  type        = bool
  default     = false
}

variable "additional_tags" {
  description = "Optional extra tags"
  type        = map(string)
  default     = {}
}
