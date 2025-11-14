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


resource "incus_instance" "dns01" {
  name    = "coredns01"
  image   = incus_image.coredns.fingerprint
  project = module.project.name
  target = "hackeriet"

  config = {
    "oci.cwd" =  "/srv/coredns01/"
  }

  device {
    # Port udp-53 forward
    name = "port-udp-33"
    type = "proxy"
    properties = {
      connect = "udp:127.0.0.1:53"
      listen = "udp:0.0.0.0:53"
    }
  }

  device {
    # Port tcp-54 forward
    name = "port-tcp-53-tailscale0"
    type = "proxy"
    properties = {
      connect = "tcp:127.0.0.1:53"
      listen = "tcp:0.0.0.0:53"
    }
  }

  # device {
  #   # Port tcp-54 forward
  #   name = "port-tcp-53"
  #   type = "proxy"
  #   properties = {
  #     connect = "tcp:127.0.0.1:53"
  #     listen = "tcp:185.35.202.243:53"
  #   }
  # }

  device {
    name = "config"
    type = "disk"
    properties = {
      source = "/srv/coredns01/"
      path = "/srv/coredns01/"
    }
  }
}
