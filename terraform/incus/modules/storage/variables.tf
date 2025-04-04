variable "cluster_members" {
  description = "list of cluster members"
  type = set(string)
}

variable "name" {
  description = "name of storage pool"
  type = string
}

variable "description" {
  description = "description of the storage pool"
  type = string
}

variable "path" {
  description = "path of the storage pool"
  type = string
}

variable "driver" {
  description = "storage diver"
  type = string
  default = "dir"
}
