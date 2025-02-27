resource "incus_network" "br_mediaserver" {
  name = "br-mediaserver"
  description = "Mediaserver network"

  config = {
    "ipv4.address" = "10.187.127.1/24"
    "ipv4.nat"     = "true"
    "ipv6.address" = "fd42:561a:1078:7eb5::1/64"
    "ipv6.nat"     = "true"
  }
}

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
    "restricted.networks.access"    = "${incus_network.br_mediaserver.name}"
  }
}



resource "incus_profile" "default" {
  name = "default"
  description = "Default Incus profile for project mediaserver" 
  project = incus_project.mediaserver.name

  device {
    name = "eth0"
    type = "nic"

    properties = {
      name = "eth0"
      network = "${incus_network.br_mediaserver.name}"
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


