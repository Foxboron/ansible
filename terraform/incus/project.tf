locals {
  cluster_members = ["hackeriet", "byggmester", "amd"]
}

locals {
  envs = { for tuple in regexall("(.*)=(.*)", file(".env")) : tuple[0] => sensitive(tuple[1]) }
}

# module "storage" {
#   source = "./modules/storage"
#   name = "nas"
#   cluster_members = local.cluster_members
#   description = "NAS storage"
#   path = "/var/incus"
# }


module "default" {
  source = "./modules/default"
}

# module "network" {
#   source = "./modules/network"
# }

module "immich" {
  source = "./modules/immich"

  immich_version  = "v2.2.3"
  postgres_version = "14-vectorchord0.4.3-pgvectors0.2.0"

  db_username =  local.envs["DB_USERNAME"]
  db_password =  local.envs["DB_PASSWORD"]
}

module "mediaserver" {
  source = "./modules/mediaserver"
}

module "webtop" {
  source = "./modules/webtop"
}

module "syncthing" {
  source = "./modules/syncthing"
}
