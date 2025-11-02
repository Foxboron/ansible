resource "incus_image" "postgres" {
  project = incus_project.immich.name
  alias {
    name = "postgres"
  }
  source_image = {
    remote = "ghcr"
    name   = "immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0"
  }
}

resource "incus_storage_volume" "postgres_data" {
  project = incus_project.immich.name
  name = "postgres-data"
  pool = "default"
}

resource "incus_instance" "database" {
  name    = "database"
  image   = incus_image.postgres.fingerprint
  project = incus_project.immich.name
  target  = "amd"

  config = {
    "boot.autorestart"                     = true
    "environment.POSTGRES_USER"            =  local.envs["DB_USERNAME"]
    "environment.POSTGRES_PASSWORD"        =  local.envs["DB_PASSWORD"]
    "environment.POSTGRES_DB"              =  local.envs["DB_DATABASE_NAME"]
    "environment.POSTGRES_INITDB_ARGS"     =  "--data-checksums"
    "environment.DB_STORAGE_TYPE"          = "HDD"
  }

  device {
    name = "postgres-data"
    type = "disk"
    properties = {
      path   = "/var/lib/postgresql/data"
      source = incus_storage_volume.postgres_data.name
      pool = "default"
    }
  }
}
