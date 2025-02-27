module "default" {
  source = "./modules/default"
}

module "immich" {
  source = "./modules/immich"
}

module "mediaserver" {
  source = "./modules/mediaserver"
}
