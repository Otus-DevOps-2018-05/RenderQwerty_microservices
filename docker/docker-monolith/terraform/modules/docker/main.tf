resource "google_compute_address" "docker" {
  name = "reddit-docker-ip"
}

resource "google_compute_target_pool" "www" {
  name      = "tf-www-target-pool"
  instances = ["${google_compute_instance.docker.*.self_link}"]
}

resource "google_compute_forwarding_rule" "http" {
  name       = "tf-www-http-forwarding-rule"
  target     = "${google_compute_target_pool.www.self_link}"
  ip_address = "${google_compute_address.docker.address}"
  port_range = "80"
}

resource "google_compute_instance" "docker" {
  count        = "${var.instance_count}"
  name         = "reddit-docker${count.index}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["reddit-docker"]

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  boot_disk {
    initialize_params {
      image = "${var.docker_disk_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["${var.puma_port}", "80"]
  }

  source_ranges = ["${var.source_range}"]
  target_tags   = ["reddit-docker"]
}
