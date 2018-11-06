variable "ssh_port" {
  description = "SSH custom port"
  default     = "22"
}

variable "source_ranges" {
  description = "Allowed ip's"
  default     = ["0.0.0.0/0"]
}
