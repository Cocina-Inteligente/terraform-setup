variable "app_name" {
  type = string
}

variable "env" {
  type = string
}

variable "location" {
  type = string
}

variable "os_type" {
  type = string
  default = "Linux"
}

variable "sku_name" {
  type = string
  default = "B1"
}

variable "https_only" {
  type = string
  default = "true"
}

variable "tls_version" {
  type = string
  default = "1.2"
}