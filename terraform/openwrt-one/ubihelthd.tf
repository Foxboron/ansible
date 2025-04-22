resource "openwrt_configfile" "ubihealthd" {
    name    = "ubihealthd"
    content = <<-EOT
        config ubi-device 'ubi0'
        	option device '/dev/ubi0'
        	option enable '1'
    EOT
}
