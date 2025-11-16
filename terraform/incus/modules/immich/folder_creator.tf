resource "incus_image" "album_creator" {
  project = incus_project.immich.name
  alias {
    name = "immich_auto_album"
  }
  source_image = {
    remote = "docker"
    name   = "salvoxia/immich-folder-album-creator"
  }
}

resource "incus_instance" "auto_album_instance_jpg" {
  name    = "auto-album-jpg"
  image   = incus_image.album_creator.fingerprint
  project = incus_project.immich.name
  target  = "amd"

  config = {
    "boot.autorestart"                     = true
    "environment.API_URL"                  = "https://bilder.linderud.dev/api/"
    "environment.API_KEY"                  = var.immich_api_key
    "environment.ROOT_PATH"                = "/mnt/bilder"
    "environment.ALBUM_LEVELS"             = "2"
    "environment.PATH_FILTER"              = "**/*.JPG"
    "environment.VISIBILITY"               = "archive"
    "environment.FIND_ARCHIVED_ASSETS"     = "1"
    "environment.UNATTENDED"               = "1"
    "environment.ALBUM_NAME_POST_REGEX1"   = "'(\\d+) (.*)' '\\2 \\1'"
    "environment.CRON_EXPRESSION"          = "0/5 * * * *" 
    "environment.TZ"                       =  "Europe/Oslo"
  }
}

resource "incus_instance" "auto_album_instance_raw" {
  name    = "auto-album-raw"
  image   = incus_image.album_creator.fingerprint
  project = incus_project.immich.name
  target  = "amd"

  config = {
    "boot.autorestart"                     = true
    "environment.API_URL"                  = "https://bilder.linderud.dev/api/"
    "environment.API_KEY"                  = var.immich_api_key
    "environment.ROOT_PATH"                = "/mnt/bilder"
    "environment.ALBUM_LEVELS"             = "2"
    "environment.PATH_FILTER"              = "**/*.ARW:**/*.DNG"
    "environment.VISIBILITY"               = "archive"
    "environment.FIND_ARCHIVED_ASSETS"     = "1"
    "environment.UNATTENDED"               = "1"
    "environment.ALBUM_NAME_POST_REGEX1"   = "'(\\d+) (.*)' '\\2 \\1 - RAW'"
    "environment.CRON_EXPRESSION"          = "0/5 * * * *" 
    "environment.TZ"                       =  "Europe/Oslo"
  }
}
