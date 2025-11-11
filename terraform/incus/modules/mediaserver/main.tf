resource "incus_project" "mediaserver" {
  name        = "mediaserver"
  description = "Mediaserver project"
  config = {
    "features.images"               = "true"
    "features.networks"             = "false"
    "features.networks.zones"       = "true"
    "features.profiles"             = "true"
    "features.storage.volumes"      = "true"
    "features.storage.buckets"      = "true"
    "restricted"                    = "true"
    "restricted.containers.nesting" = "allow"
    "restricted.devices.disk"       = "allow"
    "restricted.devices.gpu"        = "allow"
    "restricted.devices.proxy"      = "allow"
    "restricted.devices.nic"        = "allow"
    "restricted.networks.access"    = "br-mediaserver,br0"
  }
}



resource "incus_profile" "default" {
  name = "default"
  description = "Default Incus profile for project mediaserver" 
  project = incus_project.mediaserver.name

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


