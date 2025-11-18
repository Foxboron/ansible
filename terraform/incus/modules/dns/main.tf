module "project" {
  source = "../project"
  name = "dns"
}

resource "incus_image" "coredns" {
  project = module.project.name
  alias {
    name = "coredns"
  }
  source_image = {
    remote = "docker"
    name   = "coredns/coredns:1.13.1"
  }
}

resource "incus_image" "knot" {
  project = module.project.name
  alias {
    name = "knot"
  }
  source_image = {
    remote = "docker"
    name   = "cznic/knot:v3.5.1"
  }
}

resource "incus_instance" "dns01" {
  name    = "coredns01"
  image   = incus_image.knot.fingerprint
  project = module.project.name
  target = "hackeriet"
  # We override the ethernet here
  profiles = []

  config = {
    "oci.cwd"        =  "/srv/coredns01/"
    "oci.entrypoint" =  "knotd"
  }

  device {
    name = "port-proxy-udp-53"
    type = "proxy"
    properties = {
      connect = "udp:127.0.0.1:53"
      listen = "udp:185.35.202.243:53"
    }
  }

  device {
    name = "port-tailscale0-udp-53"
    type = "proxy"
    properties = {
      connect = "udp:10.177.187.83:53"
      listen = "udp:100.111.115.76:53"
      nat = "true"
    }
  }

  device {
    # Port tcp-54 forward
    name = "port-tcp-53"
    type = "proxy"
    properties = {
      connect = "tcp:10.177.187.83:53"
      listen = "tcp:185.35.202.243:53"
      nat = "true"
    }
  }

  device {
    name = "port-udp-53"
    type = "proxy"
    properties = {
      connect = "udp:10.177.187.83:53"
      listen = "udp:185.35.202.243:53"
      nat = "true"
    }
  }

  device {
    name = "root"
    type = "disk"
    properties = {
      path = "/"
      pool = "default"
    }
  }

  device {
    name = "incusbr0"
    type = "nic"
    properties = {
      "ipv4.address" = "10.177.187.83"
      "network" = "incusbr0"
    }
  }

  device {
    name = "config"
    type = "disk"
    properties = {
      source = "/srv/coredns01/"
      path = "/config"
    }
  }

  device {
    name = "storage"
    type = "disk"
    properties = {
      source = "/var/knot/"
      path = "/storage"
    }
  }
}
