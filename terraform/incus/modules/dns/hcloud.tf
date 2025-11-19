locals {
  secondary_zones_with_tsig_keyname = [ 
    for zone in var.secondary_zones: 
      merge(zone, { tsig_keyname = format("%s.%s", zone.domain, zone.ip) }) 
    ]
}

data "local_command" "keymgr" {
  for_each = { for zone in local.secondary_zones_with_tsig_keyname : zone.domain => zone }
  command   = "bash"
  arguments = ["-c", format("if [[ ! -f %s ]] then { keymgr -t %s %s | head -1 | sed 's/.*://' | tr -d '\n' | tee %s ; } else cat %s; fi ", each.value.tsig_keyname, each.value.tsig_keyname, each.value.tsig_algorithm, each.value.tsig_keyname, each.value.tsig_keyname)]
  working_directory = "/srv/hackeriet.linderud.dev/coredns01/tsig"
}

resource "hcloud_zone" "secondary_zone" {
  for_each = { for zone in local.secondary_zones_with_tsig_keyname : zone.domain => zone }
  name = each.value.domain
  mode = "secondary"

  labels = {
    "tsig_keyname" = each.value.tsig_keyname
  }

  primary_nameservers = [
    {
      address  = each.value.ip
      tsig_key = each.value.tsig_key == "" ? data.local_command.keymgr[each.key].stdout : each.value.tsig_key
      tsig_algorithm = each.value.tsig_algorithm
    },
  ]
  delete_protection = false
}
