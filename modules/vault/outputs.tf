output "vault_bucket_name" {
  value = google_storage_bucket.vault_bucket.name
}

output "vault_service_url" {
  value = google_cloud_run_service.vault_service.status[0].url
}

output "firestore_database_name" {
  value = google_firestore_database.default.name
}