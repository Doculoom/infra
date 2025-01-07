output "vault_bucket_name" {
  value = google_storage_bucket.vault_bucket.name
}

output "vault_service_url" {
  value = google_cloud_run_service.vault_service.status[0].url
}

output "vector_index_name" {
  value = google_vertex_ai_index.vector_index.display_name
}

output "vector_endpoint_name" {
  value = google_vertex_ai_index_endpoint.vector_endpoint.display_name
}

output "firestore_database_name" {
  value = google_firestore_database.default.name
}