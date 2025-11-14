variable "immich_version" {
  type = string
}

variable "postgres_version" {
  type = string
}

variable "db_username" {
  type    = string
  default = "postgres"
}

variable "db_password" {
  type      = string
  default   = "postgres"
  sensitive   = true
}

variable "db_database_name" {
  type    = string
  default = "immich"
}

variable "immich_api_key" {
  type    = string
}
