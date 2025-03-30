resource "incus_network" "br_webtop" {
  name = "br-webtop"
  description = "webtop network"
}

resource "incus_project" "webtop" {
  name        = "webtop"
  description = "webtop project"
  config = {
    "features.images"                = "true"
    "features.networks"              = "false"
    "features.networks.zones"        = "true"
    "features.profiles"              = "true"
    "features.storage.volumes"       = "true"
    "features.storage.buckets"       = "true"
    "restricted"                     = "true"
    "restricted.containers.nesting"  = "allow"
    "restricted.devices.disk"        = "allow"
    "restricted.devices.gpu"         = "allow"
    "restricted.devices.proxy"       = "allow"
    "restricted.containers.lowlevel" = "allow"
    "restricted.networks.access"       = "${incus_network.br_webtop.name}"
  }
}

resource "incus_profile" "default" {
  name = "default"
  description = "Default Incus profile for project webtop" 
  project = incus_project.webtop.name

  device {
    name = "eth0"
    type = "nic"

    properties = {
      name = "eth0"
      network = "${incus_network.br_webtop.name}"
    }
  }

  device {
    type = "disk"
    name = "root"
    properties = {
      pool = "default"
      path = "/"
    }
  }
}


