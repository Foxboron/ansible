resource "incus_network" "br_immich" {
  name = "br-immich"
  description = "immich network"
}

resource "incus_project" "immich" {
  name        = "immich"
  description = "immich project"
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
    "restricted.snapshots"           = "allow" 
    "restricted.networks.access"       = "${incus_network.br_immich.name}"
  }
}

resource "incus_profile" "default" {
  name = "default"
  description = "Default Incus profile for project immich" 
  project = incus_project.immich.name

  device {
    name = "eth0"
    type = "nic"

    properties = {
      name = "eth0"
      network = "${incus_network.br_immich.name}"
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


