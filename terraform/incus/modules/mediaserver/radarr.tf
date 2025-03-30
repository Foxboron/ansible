resource "incus_image" "radarr_img" {
  project = incus_project.mediaserver.name
  aliases = ["radarr"]
  source_image = {
    remote = "docker"
    name   = "linuxserver/radarr"
  }
}

resource "incus_storage_volume" "radarr_config" {
  project = incus_project.mediaserver.name
  name = "radarr-config"
  pool = "default"
}


resource "incus_instance" "radarr" {
  name    = "radarr"
  image   = incus_image.radarr_img.fingerprint
  project = incus_project.mediaserver.name

  config = {
    "environment.PUID"            =  "1001"
    "environment.PGID"            =  "1001"
    "environment.TZ"              =  "Europe/Oslo"
  }

  device {
    name = "port-7878"
    type = "proxy"
    properties = {
      listen = "tcp:0.0.0.0:7878"
      connect = "tcp:127.0.0.1:7878"
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
    name = "radarr-config"
    type = "disk"
    properties = {
      path   = "/config"
      source = incus_storage_volume.radarr_config.name
      pool = "default"
    }
  }
}
