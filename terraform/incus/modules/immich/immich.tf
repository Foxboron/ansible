resource "incus_image" "immich" {
  project = incus_project.immich.name
  aliases = ["immich"]
  source_image = {
    remote = "ghcr"
    name   = "immich-app/immich-server:release"
  }
}

resource "incus_instance" "immich" {
  name    = "immich"
  image   = incus_image.immich.fingerprint
  project = incus_project.immich.name

  config = {
    "boot.autorestart"                     = true
    "environment.POSTGRES_USER"            =  local.envs["DB_USERNAME"]
    "environment.POSTGRES_PASSWORD"        =  local.envs["DB_PASSWORD"]
    "environment.POSTGRES_DB"              =  local.envs["DB_DATABASE_NAME"]
    "environment.TZ"                       =  "Europe/Oslo"
  }

  device {
    # Port 2283 forward
    name = "port-2283"
    type = "proxy"
    properties = {
      listen = "tcp:0.0.0.0:2284"
      connect = "tcp:127.0.0.1:2283"
    }
  }

  lifecycle {
    ignore_changes = all
  }
}

