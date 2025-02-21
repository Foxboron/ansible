resource "incus_image" "postgres" {
  project = incus_project.immich.name
  aliases = ["postgres"]
  source_image = {
    remote = "docker"
    name   = "tensorchord/pgvecto-rs:pg14-v0.2.0"
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

  config = {
    "boot.autorestart"                     = true
    "environment.POSTGRES_USER"            =  local.envs["DB_USERNAME"]
    "environment.POSTGRES_PASSWORD"        =  local.envs["DB_PASSWORD"]
    "environment.POSTGRES_DB"              =  local.envs["DB_DATABASE_NAME"]
    "environment.POSTGRES_INITDB_ARGS"     =  "--data-checksums"
    "raw.lxc"                              = "lxc.init.cmd=/usr/lib/postgresql/14/bin/postgres -c shared_preload_libraries=vectors.so -c 'search_path=\"$user\", public, vectors' -c logging_collector=on -c max_wal_size=2GB -c shared_buffers=512MB -c wal_compression=on"
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
