resource "google_storage_bucket" "vault_bucket" {
  name          = "${var.project_id}-vault"
  location      = var.region
  force_destroy = true
  storage_class = "STANDARD"
}

resource "google_firebase_web_app" "vault_firebase" {
  provider     = google-beta
  project      = var.project_id
  display_name = "Vault Firebase"
  depends_on   = [google_firebase_project.default]
}

resource "google_cloud_run_service" "vault_service" {
  name     = "vault-service"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/vault-service:latest"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_vertex_ai_featurestore" "vault_vector_store" {
  provider = google-beta
  name     = "vault-vector-store"
  region   = var.region
  project  = var.project_id
}

terraform {
  required_providers {
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }
}

resource "google_firebase_project" "default" {
  provider = google-beta
  project  = var.project_id
}
