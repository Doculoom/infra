terraform {
  backend "gcs" {
    bucket  = "her-terraform-state-bucket"
    prefix  = "infra/state"
  }
}