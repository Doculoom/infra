output "her_bucket_name" {
  value = google_storage_bucket.her_bucket.name
}

output "her_service_url" {
  value = google_cloud_run_service.her_service.status[0].url
}