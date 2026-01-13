variable "db_username" {
  type = string
  default = "miniflux"
}

variable "db_password" {
  type = string
  default = "secret"
  sensitive   = true
}


variable "miniflux_username" {
  type = string
  default = "miniflux"
}

variable "miniflux_password" {
  type = string
  default = "secret"
  sensitive   = true
}

