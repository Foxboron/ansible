resource "openwrt_configfile" "wireless" {
    name    = "wireless"
    content = <<-EOT
        config wifi-device 'radio0'
        	option type 'mac80211'
        	option path 'platform/soc/18000000.wifi'
        	option band '2g'
        	option channel '1'
        	option htmode 'HE20'
        	option num_global_macaddr '7'
        	option disabled '1'

        config wifi-iface 'default_radio0'
        	option device 'radio0'
        	option network 'lan'
        	option mode 'ap'
        	option ssid 'OpenWrt'
        	option encryption 'none'

        config wifi-device 'radio1'
        	option type 'mac80211'
        	option path 'platform/soc/18000000.wifi+1'
        	option band '5g'
        	option channel '48'
        	option htmode 'HT40'
        	option num_global_macaddr '7'
        	option cell_density '0'

        config wifi-iface 'default_radio1'
        	option device 'radio1'
        	option network 'lan'
        	option mode 'ap'
        	option ssid 'OpenWrt'
        	option encryption 'none'
        	option disabled '1'

        config wifi-iface 'wifinet2'
        	option device 'radio1'
        	option mode 'sta'
        	option network 'wwan'
        	option ssid 'The Gibson_5G'
        	option encryption 'psk2'
        	option key '${local.envs["WIFI_AP_PASSWORD"]}'
    EOT
}
