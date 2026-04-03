resource "openwrt_configfile" "dhcp" {
    name    = "dhcp"
    content = <<-EOT
        config dnsmasq
        	option domainneeded '1'
        	option localise_queries '1'
        	option rebind_protection '1'
        	option rebind_localhost '1'
        	option local '/local/'
        	option domain 'local'
        	option expandhosts '1'
        	option cachesize '1000'
        	option authoritative '1'
        	option readethers '1'
        	option leasefile '/tmp/dhcp.leases'
        	option resolvfile '/tmp/resolv.conf.d/resolv.conf.auto'
        	option localservice '1'
        	option ednspacket_max '1232'
        	option allservers '1'
        	list server '/*.home.arpa/192.168.1.133'

        config dhcp 'lan'
        	option interface 'lan'
        	option start '100'
        	option limit '150'
        	option leasetime '12h'
        	option dhcpv4 'server'
        	option dhcpv6 'server'
        	option ra 'server'
        	list ra_flags 'managed-config'
        	list ra_flags 'other-config'
        	list dhcp_option '119,local,home.arpa'

        config dhcp 'wan'
        	option interface 'wan'
        	option ignore '1'

        config odhcpd 'odhcpd'
        	option maindhcp '0'
        	option leasefile '/tmp/odhcpd.leases'
        	option leasetrigger '/usr/sbin/odhcpd-update'
        	option loglevel '4'
        	option piodir '/tmp/odhcpd-piodir'
        	option hostsdir '/tmp/hosts'

        config host
        	option name 'hackeriet'
        	option ip '192.168.1.248'
        	list mac 'D2:D6:1C:1B:27:CB'

        config host
        	option name 'byggmester'
        	list mac '22:8E:2C:A9:4E:91'
        	option ip '192.168.1.198'
        	option dns '1'

        config host
        	option name 'amd'
        	list mac 'BE:4A:76:EA:6D:CC'
        	option ip '192.168.1.48'
        	option dns '1'

        config host
        	option name 'coredns01'
        	option ip '192.168.1.133'
        	list mac '10:66:6A:72:A3:78'
    EOT
}
