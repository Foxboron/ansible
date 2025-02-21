provider "incus" {
  generate_client_certificates = true
  accept_remote_certificate    = true

  remote {
    name    = "byggmester"
    scheme  = "https"
    address = "100.126.240.101"
    token   = "token"
    default = true
  }
}
