terraform {
  backend "gcs" {
    bucket = "otus-tf-backend_docker"
    prefix = "terraform/tfstate/stage"
  }
}
