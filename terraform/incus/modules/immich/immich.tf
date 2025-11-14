resource "incus_image" "immich" {
  project = incus_project.immich.name
  alias {
    name = "immich"
  }
  source_image = {
    remote = "ghcr"
    name   = "immich-app/immich-server:${var.immich_version}"
  }
}

resource "incus_instance" "immich" {
  name    = "immich"
  image   = incus_image.immich.fingerprint
  project = incus_project.immich.name
  target  = "amd"

  config = {
    "boot.autorestart"                     = true
    "environment.POSTGRES_USER"            =  var.db_username
    "environment.POSTGRES_PASSWORD"        =  var.db_password
    "environment.POSTGRES_DB"              =  var.db_database_name
    "oci.entrypoint"                       =  "tini -- /bin/bash -c 'sleep 5s && start.sh'"
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

  device {
    # Bilder mount
    name = "bilder"
    type = "disk"
    properties = {
      source = "/var/bilder"
      path = "/mnt/bilder"
      readonly = true
    }
  }

  device {
    # Upload mount
    name = "upload"
    type = "disk"
    properties = {
      source = "/var/immich"
      path = "/usr/src/app/upload"
    }
  }
}

