resource "incus_project" "default" {
  name        = "default"
  description = "Default Incus project"
  config = {
    "features.networks"       = "true"
    "features.networks.zones" = "true"
  }
}
