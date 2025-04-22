resource "openwrt_configfile" "ubootenv" {
    name    = "ubootenv"
    content = <<-EOT
        config ubootenv
        	option dev '/dev/ubi0_0'
        	option offset '0x0'
        	option envsize '0x1f000'
        	option secsize '0x1f000'
        	option numsec '1'

        config ubootenv
        	option dev '/dev/ubi0_1'
        	option offset '0x0'
        	option envsize '0x1f000'
        	option secsize '0x1f000'
        	option numsec '1'
    EOT
}
