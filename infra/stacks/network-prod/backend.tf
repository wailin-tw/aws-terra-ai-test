terraform {
  backend "s3" {
    bucket       = "swl-agentic-ai-prod-state-file-851725184910-ap-southeast-1-an"
    key          = "aws-terra/network-prod/prod/terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}
