resource "openwrt_configfile" "network" {
    name    = "network"
    content = <<-EOT
        config interface 'loopback'
        	option device 'lo'
        	option proto 'static'
        	option ipaddr '127.0.0.1'
        	option netmask '255.0.0.0'

        config globals 'globals'
        	option ula_prefix 'fdfb:bfdd:24e2::/48'
        	option packet_steering '1'
        	option dhcp_default_duid '000474038bd0360443be816ca09c811705c2'

        config device
        	option name 'br-lan'
        	option type 'bridge'
        	list ports 'eth1'

        config interface 'lan'
        	option device 'br-lan'
        	option proto 'static'
        	option ipaddr '192.168.1.1'
        	option netmask '255.255.255.0'
        	option ip6assign '60'
        	list dns '8.8.8.8'
        	list dns_search 'local'
        	list dns_search 'home.arpa'

        config interface 'wan'
        	option device 'eth0'
        	option proto 'dhcp'

        config interface 'wan6'
        	option device 'eth0'
        	option proto 'dhcpv6'

        config interface 'wwan'
        	option proto 'dhcp'
    EOT
}
