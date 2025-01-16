resource "google_storage_bucket" "her_bucket" {
  name          = "${var.project_id}-her"
  location      = var.region
  force_destroy = true
  storage_class = "STANDARD"
}

resource "google_cloud_run_service" "her_service" {
  name     = "her-service"
  location = var.region

  template {
    spec {
      containers {
        image = "us-central1-docker.pkg.dev/doculoom-446020/her-service/her-service:latest"
        env {
          name  = "GEMINI_API_KEY"
          value = var.gemini_key
        }
        env {
          name  = "TELEGRAM_BOT_TOKEN"
          value = var.telegram_key
        }
        resources {
          limits = {
            memory = "500Mi"
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
  project  = google_cloud_run_service.her_service.project
  location = google_cloud_run_service.her_service.location
  service  = google_cloud_run_service.her_service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}