variable "secondary_zones" {
  type = list(object({
    domain = string
    ip = optional(string, "")
    port = optional(number, 53)
    tsig_keyname = optional(string, "")
    tsig_key     = optional(string, "")
    tsig_algorithm     = optional(string, "hmac-sha256")
  }))
  default = []
}

variable "primary_dns_server" {
  type = string
  default = ""
}

variable "tsig_keys_dir" {
  type = string
  default = ""
}
