locals {
  cluster_members = ["hackeriet", "byggmester:"]
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

module "immich" {
  source = "./modules/immich"
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
