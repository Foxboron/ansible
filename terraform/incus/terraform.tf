terraform {
  required_providers {
    incus = {
      source  = "lxc/incus"
      version = "0.5.1"
    }
  }
}


provider "incus" {
  generate_client_certificates = true
  accept_remote_certificate    = true

  remote {
    name    = "local"
    scheme  = "unix"
    address = ""
  }

  remote {
    name    = "byggmester"
    scheme  = "https"
    address = "100.126.240.101"
    port    = "8444"
    token   = "token"
    default = true
  }
}
