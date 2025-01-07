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
        image = "gcr.io/${var.project_id}/vault-service:latest"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_vertex_ai_index" "vector_index" {
  provider     = google-beta
  project      = var.project_id
  region       = var.region
  display_name = "vector-search-index"
  description  = "Vector search index for similarity search"

  metadata {
    contents_delta_uri = "gs://${google_storage_bucket.vector_index_bucket.name}/contents"
    config {
      dimensions = 768
      approximate_neighbors_count = 150
      shard_size = "SHARD_SIZE_SMALL"
      distance_measure_type = "DOT_PRODUCT_DISTANCE"
      algorithm_config {
        tree_ah_config {
          leaf_node_embedding_count = 500
          leaf_nodes_to_search_percent = 7
        }
      }
    }
  }
}

resource "google_vertex_ai_index_endpoint" "vector_endpoint" {
  provider     = google-beta
  display_name = "vector-search-endpoint"
  description  = "Vector search endpoint"
  region       = var.region

  private_service_connect_config {
    enable_private_service_connect = true
    project_allowlist = [var.project_id]
  }
}
