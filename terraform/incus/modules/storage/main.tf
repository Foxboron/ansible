resource "incus_storage_pool" "cluster_member_pools" {
  for_each = var.cluster_members
  name   = var.name
  driver = var.driver
  config = {
    source = var.path
    "rsync.compression" = false
  }
  target = each.value
}


resource "incus_storage_pool" "pool" {
  count = length(var.cluster_members) != 0 ? 1 : 0 
  name   = var.name
  driver = var.driver
  config = {
    "rsync.compression" = false
  }
  depends_on = [ incus_storage_pool.cluster_member_pools ]
}
