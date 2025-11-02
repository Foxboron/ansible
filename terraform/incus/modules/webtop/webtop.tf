resource "incus_image" "webtop" {
  project = incus_project.webtop.name
  alias {
    name        = "webtop"
  }
  source_image = {
    remote = "lscr"
    name   = "linuxserver/webtop:arch-i3"
  }
}

resource "incus_instance" "webtop" {
  name    = "webtop"
  image   = incus_image.webtop.fingerprint
  project = incus_project.webtop.name

  config = {
    "boot.autorestart"                     = true
    "environment.PUID"                     =  "1000"
    "environment.PGID"                     =  "1000"
    "environment.TZ"                       =  "Europe/Oslo"
    "environment.HOME"                     =  "/config"
  }

  device {
    # Port 3000 forward
    name = "port-3000"
    type = "proxy"
    properties = {
      listen = "tcp:0.0.0.0:3000"
      connect = "tcp:127.0.0.1:3000"
    }
  }

  device {
    # Port 3001 forward
    name = "port-3001"
    type = "proxy"
    properties = {
      listen = "tcp:0.0.0.0:3001"
      connect = "tcp:127.0.0.1:3001"
    }
  }

  device {
    # Port 8201 forward
    name = "port-8201"
    type = "proxy"
    properties = {
      listen = "udp:0.0.0.0:8201"
      connect = "udp:127.0.0.1:8201"
    }
  }

  device {
    # Port 8202 forward
    name = "port-8202"
    type = "proxy"
    properties = {
      listen = "udp:0.0.0.0:8202"
      connect = "udp:127.0.0.1:8202"
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

  lifecycle {
    ignore_changes = all
  }
}

