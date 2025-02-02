resource "google_firestore_database" "default" {
  name       = "vault"
  project    = var.project_id
  location_id = var.region
  type       = "FIRESTORE_NATIVE"
}


resource "google_storage_bucket" "vault_bucket" {
  name          = "${var.project_id}-vault"
  location      = var.region
  force_destroy = true
  storage_class = "STANDARD"
}

resource "google_storage_bucket" "vector_index_bucket" {
  name          = "${var.project_id}-vector-index"
  location      = var.region
  force_destroy = true
  storage_class = "STANDARD"
}

resource "google_cloud_run_service" "vault_service" {
  name     = "vault-service"
  location = var.region

  template {
    spec {
      containers {
        image = "us-central1-docker.pkg.dev/doculoom-446020/vault-service/vault-service:latest"
        env {
          name  = "GEMINI_API_KEY"
          value = var.gemini_key
        }
        resources {
          limits = {
            memory = "1Gi"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}


resource "google_cloud_run_service_iam_member" "public_invoker" {
  project  = google_cloud_run_service.vault_service.project
  location = google_cloud_run_service.vault_service.location
  service  = google_cloud_run_service.vault_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_firestore_index" "timestamp_index" {
  project     = var.project_id
  collection  = "chat_history"
  query_scope = "COLLECTION"

  fields {
    field_path = "timestamp"
    order      = "ASCENDING"
  }
}

resource "google_firestore_index" "memories_vector_index" {
  project    = var.project_id
  database   = "vault"
  collection = "memories"

  fields {
    field_path = "user_id"
    order      = "ASCENDING"
  }

  fields {
    field_path = "embedding"
    vector_config {
      dimension = 768
      flat {}
    }
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      fields
    ]
  }
}




