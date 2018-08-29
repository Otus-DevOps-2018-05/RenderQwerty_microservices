variable "project" {
  description = "Project id"
}

variable "region" {
  description = "Region"
  default     = "europe-west1"
}

variable "zone" {
  description = "Zone"
  default     = "europe-west1-b"
}

variable "public_key_path" {
  description = "Path to the public key used for ssh access"
}

variable "private_key_path" {
  description = "Path to private ssh key for provisioners"
}

variable "disk_image" {
  description = "Disk image"
}

variable "instance_count" {
  description = "Count of docker instances for load balancing"
  default     = "1"
}

variable docker_disk_image {
  description = "Disk image for docker-reddit"
  default     = "docker-host"
}

variable "source_range" {
  type        = "list"
  description = "allow access from this ip's"
  default     = ["0.0.0.0/0"]
}

variable "docker_provision_status" {
  description = "enable or disable provision scripts"
  default     = "false"
}

variable "ssh_port" {
  description = "ssh port for instance"
}
