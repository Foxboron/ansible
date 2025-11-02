resource "incus_image" "jellyfin_img" {
  project = incus_project.mediaserver.name
  alias {
    name = "jellyfin"
  }
  source_image = {
    remote = "docker"
    name   = "linuxserver/jellyfin"
  }
}

resource "incus_storage_volume" "jellyfin_cache" {
  project = incus_project.mediaserver.name
  name = "jellyfin-cache"
  pool = "default"
}

resource "incus_storage_volume" "jellyfin_config" {
  project = incus_project.mediaserver.name
  name = "jellyfin-config"
  pool = "default"
}


resource "incus_instance" "jellyfin" {
  name    = "jellyfin"
  image   = incus_image.jellyfin_img.fingerprint
  project = incus_project.mediaserver.name
  target = "amd"

  config = {
    "environment.PUID" =  "1001"
    "environment.PGID" =  "1001"
    "environment.TZ"   =  "Europe/Oslo"
  }

  device {
    # Port 8096 forward
    name = "port-8096"
    type = "proxy"
    properties = {
      listen = "tcp:0.0.0.0:8096"
      connect = "tcp:127.0.0.1:8096"
    }
  }

  device {
    # Media mount
    name = "media"
    type = "disk"
    properties = {
      source = "/var/mediaserver/media/"
      path = "/media/"
      readonly = true
    }
  }

  device {
    # Media mount
    name = "dri-mount"
    type = "disk"
    properties = {
      source = "/dev/dri/"
      path = "/dev/dri/"
    }
  }

  device {
    name = "jellyfin-cache"
    type = "disk"
    properties = {
      path   = "/cache"
      source = incus_storage_volume.jellyfin_cache.name
      pool = "default"
    }
  }

  device {
    name = "jellyfin-config"
    type = "disk"
    properties = {
      path   = "/config"
      source = incus_storage_volume.jellyfin_config.name
      pool = "default"
    }
  }
}
