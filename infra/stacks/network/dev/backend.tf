terraform {
  backend "s3" {
    bucket       = "swl-agentic-ai-stg-state-file-851725184910-ap-southeast-1-an"
    key          = "state/network/dev/terraform.tfstate"
    region       = "ap-southeast-1"
    encrypt      = true
    use_lockfile = true
  }
}
