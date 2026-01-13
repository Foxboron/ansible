module "project" {
  source = "../project"
  name = "miniflux"
}


# resource "incus_image" "image" {
#   project = module.project.name
#   alias {
#     name = "miniflux"
#   }
#   source_image = {
#     remote = "docker"
#     name   = "miniflux/miniflux:latest"
#   }
# }


resource "incus_instance" "miniflux" {
  name    = "miniflux"
  image   = "53b29927da35"
  project = module.project.name
  target = "amd"

  config = {
    "boot.autorestart"                  = true
    "environment.TZ"			= "Europe/Oslo"
    "environment.DATABASE_URL"		= "postgres://${var.db_username}:${var.db_password}@miniflux-db.local/miniflux?sslmode=disable"
    "environment.RUN_MIGRATIONS"	= 1
    "environment.ADMIN_USERNAME"	= "${var.miniflux_username}"
    "environment.ADMIN_PASSWORD"	= "${var.miniflux_password}"
    "oci.entrypoint"                    = "/bin/sh -c 'sleep 10s && /usr/bin/miniflux'"
  }
}

# resource "incus_image" "pg_image" {
#   project = module.project.name
#   alias {
#     name = "miniflux_postgres"
#   }
#   source_image = {
#     remote = "docker"
#     name   = "postgres:18"
#   }
# }

resource "incus_storage_volume" "storage" {
  project = module.project.name
  name = "miniflux_db"
  pool = "default"
  target = "amd"
}

resource "incus_instance" "db" {
  name    = "miniflux-db"
  image   = "14b0bd64f359"
  project = module.project.name
  target = "amd"

  config = {
    "environment.TZ"			= "Europe/Oslo"
    "environment.POSTGRES_USER"		= "${var.db_username}"
    "environment.POSTGRES_PASSWORD"	= "${var.db_password}"
    "environment.POSTGRES_DB"		= "miniflux"
  }

  device {
    name = "miniflux_db"
    type = "disk"
    properties = {
      source = incus_storage_volume.storage.name
      pool = "default"
      path = "/var/lib/postgresql"
    }
  }
}
