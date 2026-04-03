resource "openwrt_configfile" "umdns" {
    name    = "umdns"
    content = <<-EOT
        config umdns
        	option jail 1
        	list network lan
    EOT
}
