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
  target = "byggmester"
  # We override the ethernet here
  profiles = []

  config = {
    "oci.cwd"        =  "/srv/coredns01/"
    "oci.entrypoint" =  "knotd"
  }


  device {
    # Port tcp-54 forward
    name = "port-tcp-53"
    type = "proxy"
    properties = {
      connect = "tcp:10.177.187.83:53"
      listen = "tcp:10.100.200.2:53"
      nat = "true"
    }
  }

  device {
    name = "port-tcp-53-v6"
    type = "proxy"
    properties = {
      connect = "tcp:[fd42:4bf7:ed45:756e:6376:c294:9e7e:8c2b]:53"
      listen = "tcp:[fdc9::2]:53"
      nat = "true"
    }
  }

  device {
    name = "port-udp-53"
    type = "proxy"
    properties = {
      connect = "udp:10.177.187.83:53"
      listen = "udp:10.100.200.2:53"
      nat = "true"
    }
  }

  device {
    name = "port-udp-53-v6"
    type = "proxy"
    properties = {
      connect = "udp:[fd42:4bf7:ed45:756e:6376:c294:9e7e:8c2b]:53"
      listen = "udp:[fdc9::2]:53"
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
      "network" = "incusbr0"
      "ipv4.address" = "10.177.187.83"
      "ipv6.address" = "fd42:4bf7:ed45:756e:6376:c294:9e7e:8c2b"
    }
  }

  device {
    name = "br0"
    type = "nic"
    properties = {
      "nictype" = "bridged"
      "parent" = "br0"
    }
  }

  device {
    name = "config"
    type = "disk"
    properties = {
      source = "/var/syncthing/data1/linderud.dev/coredns01/"
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
