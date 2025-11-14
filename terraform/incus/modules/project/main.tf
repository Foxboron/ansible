resource "incus_project" "project" {
  name        = "${var.name}"
  description = "${var.name} project"
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
    "restricted.devices.nic"         = "allow"
    "restricted.networks.access"     = "incusbr0,br0"
  }
}

resource "incus_profile" "default" {
  name = "default"
  description = "Default Incus profile for project ${var.name}"
  project = incus_project.project.name

  device {
    name = "eth0"
    properties = {
      "nictype" = "bridged"
      "parent"  = "br0"
    }
    type = "nic"
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

