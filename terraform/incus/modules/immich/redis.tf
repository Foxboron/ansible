resource "incus_image" "redis" {
  project = incus_project.immich.name
  alias {
    name = "redis"
  }
  source_image = {
    remote = "docker"
    name   = "valkey/valkey:8-bookworm"
  }
}

resource "incus_instance" "immich_redis" {
  name    = "redis"
  image   = incus_image.redis.fingerprint
  project = incus_project.immich.name
  target  = "amd"

  config = {
    "boot.autorestart"                     = true
  }
}

