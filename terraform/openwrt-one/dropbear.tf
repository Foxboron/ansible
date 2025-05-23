resource "openwrt_configfile" "dropbear" {
    name    = "dropbear"
    content = <<-EOT
        # See https://openwrt.org/docs/guide-user/base-system/dropbear
        config dropbear main
        	option enable '1'
        	option PasswordAuth 'on'
        	option RootPasswordAuth 'on'
        	option Port         '22'
        #	option BannerFile   '/etc/banner'
    EOT
}
