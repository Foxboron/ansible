resource "incus_image" "machine_learning" {
  project = incus_project.immich.name
  alias {
    name = "machine_learning"
  }
  source_image = {
    remote = "ghcr"
    name   = "immich-app/immich-machine-learning:${var.immich_version}"
  }
}

resource "incus_storage_volume" "model_cache" {
  project = incus_project.immich.name
  name = "model-cache"
  pool = "default"
}

resource "incus_instance" "machine_learning" {
  name    = "immich-machine-learning"
  image   = incus_image.machine_learning.fingerprint
  project = incus_project.immich.name
  target  = "amd"

  config = {
    "boot.autorestart"                     = true
  }

  device {
    name = "model-cache"
    type = "disk"
    properties = {
      path   = "/cache"
      source = incus_storage_volume.model_cache.name
      pool = "default"
    }
  }
}

