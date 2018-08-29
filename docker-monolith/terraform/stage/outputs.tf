output "instance_ip" {
  value = "${module.docker.docker_ip}"
}

output "public_ip" {
  value = "${module.docker.public_ip}"
}
