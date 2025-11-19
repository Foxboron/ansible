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
    "restricted.snapshots"           = "allow"
    "restricted.devices.nic"         = "allow"
    "restricted.networks.access"       = "br0"
  }
}

resource "incus_profile" "default" {
  name = "default"
  description = "Default Incus profile for project webtop" 
  project = incus_project.webtop.name

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


