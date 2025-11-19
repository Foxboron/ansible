terraform {
  required_providers {
    incus = {
      source  = "lxc/incus"
      version = "1.0.0"
    }
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.56.0"
    }
  }
}


provider "incus" {
  generate_client_certificates = true
  accept_remote_certificate    = true
  default_remote = "byggmester"

  remote {
    name    = "local"
    address = "unix://"
  }

  remote {
    name    = "byggmester"
    address = "https://100.126.240.101:8444"
    token   = "token"
  }

  remote {
    name     = "dockerio"
    address  = "https://docker.io"
    protocol = "oci"
    public   = true
  }

  remote {
    name     = "ghcr"
    address  = "https://ghcr.io"
    protocol = "oci"
    public   = true
  }

  remote {
    name     = "lscr"
    address  = "https://lscr.io"
    protocol = "oci"
    public   = true
  }
}
