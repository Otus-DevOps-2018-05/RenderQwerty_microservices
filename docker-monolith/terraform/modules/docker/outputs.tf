output "docker_ip" {
  value = "${join(" ", google_compute_instance.docker.*.network_interface.0.access_config.0.assigned_nat_ip)}"
}

output "public_ip" {
  value = "${google_compute_address.docker.address}"
}
