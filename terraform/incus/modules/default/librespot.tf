
resource "incus_image" "librespot" {
  project = "default"
  alias {
    name = "librespot"
  }
  source_image = {
    remote = "docker"
    name   = "giof71/librespot:latest"
  }
}

resource "incus_instance" "librespot" {
  name    = "librespot"
  image   = incus_image.librespot.fingerprint
  project = "default"
  target = "amd"

  # librespot --name "Stua" --device "plughw:CARD=Generic_1" --backend alsa --initial-volume 100 --format S32 --bitrate 320 --autoplay on
  config = {
    "boot.autorestart"            = true
    "environment.TZ"              = "Europe/Oslo"
    "environment.BITRATE"         = "320"
    "environment.DEVICE_NAME"     = "Stua"
    "environment.DEVICE"          = "plughw:CARD=Generic_1"
    "environment.BACKEND"         = "alsa"
    "environment.INITIAL_VOLUME"  = "100"
    "environment.AUTOPLAY"        = "y"
    "oci.entrypoint"              = "/usr/bin/bash -c 'sleep 5s && /app/bin/run-librespot.sh'"
  }

  device {
    name = "controlC1"
    type = "unix-char"
    properties = {
      path = "/dev/snd/controlC1"
      gid = 0
    }
  }

  device {
    name = "pcmC1D0p"
    type = "unix-char"
    properties = {
      path = "/dev/snd/pcmC1D0p"
      gid = 0
    }
  }
}
