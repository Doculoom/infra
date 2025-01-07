output "vault_bucket_name" {
  value = google_storage_bucket.vault_bucket.name
}

output "vault_firebase_project_name" {
  value = google_firebase_web_app.vault_firebase.display_name
}

output "vault_service_url" {
  value = google_cloud_run_service.vault_service.status[0].url
}

output "vault_vector_store_name" {
  value = google_vertex_ai_featurestore.vault_vector_store.name
}
