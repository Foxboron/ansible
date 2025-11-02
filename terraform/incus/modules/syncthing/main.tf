module "syncthing_project" {
  source = "../project"
  name = "syncthing"
}


resource "incus_image" "syncthing" {
  project = module.syncthing_project.name
  alias {
    name = "syncthing"
  }
  source_image = {
    remote = "docker"
    name   = "linuxserver/syncthing"
  }
}


resource "incus_instance" "syncthing" {
  name    = "syncthing"
  image   = incus_image.syncthing.fingerprint
  project = module.syncthing_project.name
  target = "amd"

  config = {
    "environment.PUID" =  "1001"
    "environment.PGID" =  "1001"
    "environment.TZ"   =  "Europe/Oslo"
  }

  device {
    # Port 8384 forward
    name = "port-tcp-8384"
    type = "proxy"
    properties = {
      listen = "tcp:0.0.0.0:8384"
      connect = "tcp:127.0.0.1:8384"
    }
  }

  device {
    # Port 8384 forward
    name = "port-tcp-8384-80"
    type = "proxy"
    properties = {
      listen = "tcp:0.0.0.0:80"
      connect = "tcp:127.0.0.1:8384"
    }
  }

  device {
    # Port 22000 forward
    name = "port-tcp-22000"
    type = "proxy"
    properties = {
      listen = "tcp:0.0.0.0:22000"
      connect = "tcp:127.0.0.1:22000"
    }
  }

  device {
    # Port 22000 forward
    name = "port-udp-22000"
    type = "proxy"
    properties = {
      listen = "udp:0.0.0.0:22000"
      connect = "udp:127.0.0.1:22000"
    }
  }

  device {
    # Port 22000 forward
    name = "port-udp-21027"
    type = "proxy"
    properties = {
      listen = "udp:0.0.0.0:21027"
      connect = "udp:127.0.0.1:21027"
    }
  }

  device {
    # Config mount
    name = "config"
    type = "disk"
    properties = {
      source = "/var/syncthing/config/"
      path = "/config/"
    }
  }

  device {
    # data1 mount
    name = "data1"
    type = "disk"
    properties = {
      source = "/var/syncthing/data1/"
      path = "/data1/"
    }
  }

  device {
    # data2 mount
    name = "data2"
    type = "disk"
    properties = {
      source = "/var/syncthing/data2/"
      path = "/data2/"
    }
  }
}
