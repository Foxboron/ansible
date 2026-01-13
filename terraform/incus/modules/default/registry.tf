resource "incus_storage_volume" "registry" {
  project = "default"
  name = "registry"
  pool = "default"
}

resource "incus_image" "registry" {
  project = "default"
  alias {
    name = "registry"
  }
  source_image = {
    remote = "docker"
    name   = "registry:3"
  }
}

resource "incus_instance" "registry" {
  name    = "registry"
  image   = incus_image.registry.fingerprint
  project = "default"
  target = "byggmester"

  device {
    name = "registry-var-lib"
    type = "disk"
    properties = {
      source = incus_storage_volume.registry.name
      pool = "default"
      path = "/var/lib/registry"
    }
  }
}
