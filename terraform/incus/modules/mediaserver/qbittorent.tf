resource "incus_image" "qbittorrent_img" {
  project = incus_project.mediaserver.name
  aliases = ["qbittorrent"]
  source_image = {
    remote = "docker"
    name   = "linuxserver/qbittorrent"
  }
}

resource "incus_storage_volume" "qbittorrent_config" {
  project = incus_project.mediaserver.name
  name = "qbittorrent-config"
  pool = "default"
}


resource "incus_instance" "qbittorrent" {
  name    = "qbittorrent"
  image   = incus_image.qbittorrent_img.fingerprint
  project = incus_project.mediaserver.name

  config = {
    "environment.PUID"            = "1001"
    "environment.PGID"            = "1001"
    "environment.TZ"              = "Europe/Oslo"
    "environment.WEBUI_PORT"      = "8080"
    "environment.TORRENTING_PORT" = "17430" 
    "environment.HOME"            = "/config" 
  }

  device {
    name = "port-8080"
    type = "proxy"
    properties = {
      listen = "tcp:0.0.0.0:8080"
      connect = "tcp:127.0.0.1:8080"
    }
  }

  device {
    name = "port-17430-tcp"
    type = "proxy"
    properties = {
      listen = "tcp:0.0.0.0:14730"
      connect = "tcp:127.0.0.1:14730"
    }
  }

  device {
    name = "port-17430-udp"
    type = "proxy"
    properties = {
      listen = "udp:0.0.0.0:17430"
      connect = "udp:127.0.0.1:17430"
    }
  }

  device {
    # Torrent mount
    name = "torrents"
    type = "disk"
    properties = {
      source = "/var/torrents/"
      path = "/downloads/"
    }
  }

  device {
    name = "qbittorrent-config"
    type = "disk"
    properties = {
      path   = "/config"
      source = incus_storage_volume.qbittorrent_config.name
      pool = "default"
    }
  }
}
