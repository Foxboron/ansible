# resource "incus_instance" "pihole" {
#   name  = "pihole"
#   image = "docker:pihole/pihole"
#   profiles = ["default", "macvlan"]
# }

# resource "incus_instance" "instance1" {
#   name  = "instance1"
#   image = "images:ubuntu/22.04"

#   config = {
#     "boot.autostart" = true
#     "limits.cpu" = 2
#   }
# }
