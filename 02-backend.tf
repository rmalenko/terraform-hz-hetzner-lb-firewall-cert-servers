terraform {
  cloud {
    organization = "photographer-rnd"

    workspaces {
      name = "hetzner_rnd"
    }
  }
}