resource "incus_image" "redis" {
  project = incus_project.immich.name
  aliases = ["redis"]
  source_image = {
    remote = "docker"
    name   = "redis:6.2-alpine"
  }
}

resource "incus_instance" "immich_redis" {
  name    = "redis"
  image   = incus_image.redis.fingerprint
  project = incus_project.immich.name

  config = {
    "boot.autorestart"                     = true
  }
}

