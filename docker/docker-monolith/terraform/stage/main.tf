provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "docker" {
  source            = "../modules/docker"
  public_key_path   = "${var.public_key_path}"
  private_key_path  = "${var.private_key_path}"
  zone              = "${var.zone}"
  source_range      = "${var.source_range}"
  docker_disk_image = "${var.docker_disk_image}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["${var.source_range}"]
}
