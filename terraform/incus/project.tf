locals {
  cluster_members = ["hackeriet", "byggmester", "amd"]
}

locals {
  envs = { for tuple in regexall("(.*)=(.*)", file(".env")) : tuple[0] => sensitive(tuple[1]) }
  primary_dns_server = "185.35.202.243"
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

module "dns" {
  source = "./modules/dns"
  tsig_keys_dir = "/srv/hackeriet.linderud.dev/coredns01/tsig/"
  primary_dns_server = local.primary_dns_server
  secondary_zones = [
    { domain = "bloat.dev" },
    { domain = "secureboot.dev" },
    { domain = "linderud.dev" },
    { domain = "linderud.pw" },
  ]
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

  immich_api_key = local.envs["IMMICH_API_KEY"]
}

module "mediaserver" {
  source = "./modules/mediaserver"
}

# module "webtop" {
#   source = "./modules/webtop"
# }

module "syncthing" {
  source = "./modules/syncthing"
}
