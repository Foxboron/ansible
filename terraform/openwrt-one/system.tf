resource "openwrt_configfile" "system" {
    name    = "system"
    content = <<-EOT
        config system
        	option hostname 'TheGibson'
        	option timezone 'UTC'
        	option ttylogin '0'
        	option log_size '128'
        	option urandom_seed '0'

        config timeserver 'ntp'
        	option enabled '1'
        	option enable_server '0'
        	list server '0.openwrt.pool.ntp.org'
        	list server '1.openwrt.pool.ntp.org'
        	list server '2.openwrt.pool.ntp.org'
        	list server '3.openwrt.pool.ntp.org'

        config led 'led_wanact'
        	option name 'WANACT'
        	option sysfs 'mdio-bus:0f:green:wan'
        	option trigger 'netdev'
        	option mode 'rx tx'
        	option dev 'eth0'

        config led 'led_wanlink'
        	option name 'WANLINK'
        	option sysfs 'mdio-bus:0f:amber:wan'
        	option trigger 'netdev'
        	option mode 'link'
        	option dev 'eth0'

        config led 'led_lanact'
        	option name 'LANACT'
        	option sysfs 'green:lan'
        	option trigger 'netdev'
        	option mode 'rx tx'
        	option dev 'eth1'

        config led 'led_lanlink'
        	option name 'LANLINK'
        	option sysfs 'amber:lan'
        	option trigger 'netdev'
        	option mode 'link'
        	option dev 'eth1'
    EOT
}
