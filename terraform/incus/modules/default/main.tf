resource "incus_project" "default" {
  name        = "default"
  description = "Default Incus project"
  config      = {
    "features.networks"       = "true"
    "features.networks.zones" = "true"
  }
}

resource "incus_profile" "default" {
  description = "Default Incus profile"
  name        = "default"

  config = {
    "security.secureboot" = "false"
  }

  device {
    name = "eth0"
    properties = {
      "name"    = "eth0"
      "network" = "lxdbr0"
    }
    type = "nic"
  }
  device {
    name = "root"
    properties = {
      "path" = "/"
      "pool" = "default"
    }
    type = "disk"
  }
}

resource "incus_profile" "macvlan" {
  name = "macvlan"

  device {
    name = "eth0"
    properties = {
      "nictype" = "macvlan"
      "parent"  = "eno1"
    }
    type = "nic"
  }
}
