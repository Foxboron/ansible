variable "secondary_zones" {
  type = list(object({
    domain = string
    ip = string
    port = optional(number, 53)
    tsig_keyname = optional(string, "")
    tsig_key     = optional(string, "")
    tsig_algorithm     = optional(string, "hmac-sha256")
  }))
  default = []
}

variable "tsig_keys_dir" {
  type = string
  default = ""
}
