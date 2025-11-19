# Set porkbun DNS NS records
resource "porkbun_nameservers" "domains" {
  for_each = { for zone in local.secondary_zones_with_tsig_keyname : zone.domain => zone }
  domain      = each.value.domain
  nameservers = var.ns_records
}
