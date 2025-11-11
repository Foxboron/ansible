terraform {
  required_providers {
    openwrt = {
      source = "foxboron/openwrt"
    }
  }
}

provider "openwrt" {
  user = "root"
  password = "admin"
  remote = "http://192.168.1.1"
}
