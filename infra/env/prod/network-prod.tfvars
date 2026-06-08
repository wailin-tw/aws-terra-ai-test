aws_region   = "ap-southeast-1"
project_name = "agentic-prod"

owner       = "platform-team"
cost_center = "cc-1001"
application = "aws-terra"
environment = "prod"

vpc_cidr = "10.50.0.0/16"

availability_zones = [
  "ap-southeast-1a",
  "ap-southeast-1b"
]

public_subnet_cidrs = [
  "10.50.1.0/24",
  "10.50.2.0/24"
]

private_subnet_cidrs = [
  "10.50.11.0/24",
  "10.50.12.0/24"
]

# Enable NAT in prod for private subnet egress.
enable_nat_gateway = true

additional_tags = {
  purpose = "production"
}
