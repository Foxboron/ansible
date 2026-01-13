module "project" {
  source = "../project"
  name = "ca"
}

resource "incus_image" "image" {
  project = module.project.name
  alias {
    name = "step-ca"
  }
  source_image = {
    remote = "docker"
    name   = "smallstep/step-ca:${var.step_ca_version}"
  }
}

resource "incus_profile" "default" {
  name = "default"
  description = "Default Incus profile for project ${var.name}"
  project = module.project.name

  device {
    name = "eth0"
    properties = {
      "nictype" = "bridged"
      "parent"  = "br0"
    }
    type = "nic"
  }

  device {
    type = "disk"
    name = "root"
    properties = {
      pool = "default"
      path = "/"
    }
  }
}

resource "incus_storage_volume" "storage" {
  project = module.project.name
  name = "step-ca"
  pool = "default"
}



resource "incus_instance" "ca" {
  name    = "ca"
  image   = incus_image.image.fingerprint
  project = module.project.name
  target = "byggmester"

  config = {
    "environment.TZ"   =  "Europe/Oslo"
    "environment.DOCKER_STEPCA_INIT_NAME"              = "Linderud Internal CA"
    "environment.DOCKER_STEPCA_INIT_DNS_NAMES"         = "localhost,ca.local,ca.linderud.dev,ca.home.arpa"
    "environment.DOCKER_STEPCA_INIT_SSH"               = "true"
    "environment.DOCKER_STEPCA_INIT_ACME"              = "true"
    "environment.DOCKER_STEPCA_INIT_REMOTE_MANAGEMENT" = "true"
    "environment.DOCKER_STEPCA_INIT_ADDRESS"           = ":443"
  }

  device {
    # step-ca mount
    name = "step-ca"
    type = "disk"
    properties = {
      source = incus_storage_volume.storage.name
      pool = "default"
      path = "/home/step"
    }
  }
}
