resource "openwrt_configfile" "wireless" {
    name    = "wireless"
    content = <<-EOT
        config wifi-device 'radio0'
        	option type 'mac80211'
        	option path 'platform/soc/18000000.wifi'
        	option band '2g'
        	option channel '1'
        	option num_global_macaddr '7'
        	option cell_density '0'
        	option country 'NO'
        	option legacy_rates '1'

        config wifi-device 'radio1'
        	option type 'mac80211'
        	option path 'platform/soc/18000000.wifi+1'
        	option band '5g'
        	option channel '48'
        	option htmode 'HE160'
        	option num_global_macaddr '7'
        	option cell_density '0'
        	option country 'NO'

        config wifi-iface 'wifinet0'
        	option device 'radio1'
        	option mode 'ap'
        	option ssid 'OpenWrt'
        	option encryption 'none'
        	option disabled '1'

        config wifi-iface 'wifinet1'
        	option device 'radio1'
        	option mode 'ap'
        	option ssid 'The Gibson'
        	option encryption 'sae-mixed'
        	option key '${local.envs["WIFI_AP_PASSWORD"]}'
        	option ocv '0'
        	option network 'lan'

        config wifi-iface 'wifinet2'
        	option device 'radio0'
        	option mode 'ap'
        	option ssid 'Roborock'
        	option encryption 'psk2'
        	option key '${local.envs["WIFI_AP_PASSWORD"]}'
        	option network 'lan'
    EOT
}
