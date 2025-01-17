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
        env {
          name  = "VAULT_API_URL"
          value = var.vault_api_url
        }
        env {
          name  = "HER_API_URL"
          value = var.her_api_url
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


resource "google_project_iam_member" "cloudtasks_admin" {
  project = var.project_id
  role    = "roles/cloudtasks.admin"
  member  = "serviceAccount:${var.service_account_email}"
}

resource "google_cloud_tasks_queue" "her_queue" {
  name     = "her-queue"
  location = var.region
  project  = var.project_id
}
