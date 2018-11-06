variable "project" {
  description = "Project id"
}

variable "region" {
  description = "Region"
  default     = "europe-west4"
}

variable "zone" {
  description = "Zone"
  default     = "europe-west4-a"
}

variable "private_key_path" {
  description = "Path to private ssh key"
}

variable "public_key_path" {
  description = "Path to public ssh key"
}
