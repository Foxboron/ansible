resource "openwrt_configfile" "rpcd" {
    name    = "rpcd"
    content = <<-EOT
        config rpcd
        	option socket /var/run/ubus/ubus.sock
        	option timeout 30

        config login
        	option username 'root'
        	option password '$p$root'
        	list read '*'
        	list write '*'
    EOT
}
