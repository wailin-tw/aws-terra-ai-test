aws_region   = "ap-southeast-1"
project_name = "agentic-test"

owner       = "platform-team"
cost_center = "cc-1001"
application = "aws-terra"
environment = "dev"

vpc_cidr = "10.40.0.0/16"

availability_zones = [
  "ap-southeast-1a",
  "ap-southeast-1b"
]

public_subnet_cidrs = [
  "10.40.1.0/24",
  "10.40.2.0/24"
]

private_subnet_cidrs = [
  "10.40.11.0/24",
  "10.40.12.0/24"
]

# Keep false in dev to reduce cost unless private egress is required.
enable_nat_gateway = false

additional_tags = {
  purpose = "development"
}