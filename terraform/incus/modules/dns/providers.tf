terraform {
  required_providers {
    incus = {
      source  = "lxc/incus"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
    }
    porkbun = {
      source = "marcfrederick/porkbun"
    }
  }
}

