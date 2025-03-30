resource "incus_image" "sonarr_img" {
  project = incus_project.mediaserver.name 
  aliases = ["sonarr"]
  source_image = {
    remote = "docker"
    name   = "linuxserver/sonarr"
  }
}

resource "incus_storage_volume" "sonarr_config" {
  project = incus_project.mediaserver.name
  name = "sonarr-config"
  pool = "default"
}


resource "incus_instance" "sonarr" {
  name    = "sonarr"
  image   = incus_image.sonarr_img.fingerprint
  project = incus_project.mediaserver.name

  config = {
    "environment.PUID"            =  "1001"
    "environment.PGID"            =  "1001"
    "environment.TZ"              =  "Europe/Oslo"
  }

  device {
    name = "port-8989"
    type = "proxy"
    properties = {
      listen = "tcp:0.0.0.0:8989"
      connect = "tcp:127.0.0.1:8989"
    }
  }

  device {
    # Media mount
    name = "media"
    type = "disk"
    properties = {
      source = "/var/mediaserver/"
      path = "/data/"
    }
  }

  device {
    name = "sonarr-config"
    type = "disk"
    properties = {
      path   = "/config"
      source = incus_storage_volume.sonarr_config.name
      pool = "default"
    }
  }
}
