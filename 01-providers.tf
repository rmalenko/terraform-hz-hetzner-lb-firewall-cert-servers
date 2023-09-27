# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs

# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.43.0"
    }
    hetznerdns = {
      source  = "timohirt/hetznerdns"
      version = ">= 2.2.0"
    }
  }
}

provider "hetznerdns" {
  apitoken = var.htzner_dns_token
}