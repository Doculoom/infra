variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "gemini_key" {
  description = "Gemini Key"
  type        = string
}

variable "telegram_key" {
  description = "Telegram API Key"
  type        = string
}

variable "vault_api_url" {
  description = "Vault API Url"
  type        = string
}

variable "her_api_url" {
  description = "Her API Url"
  type        = string
}

variable "service_account_email" {
  description = "Service account email"
  type        = string
}

variable "google_api_key" {
  description = "Google API Key"
  type        = string
}

variable "memory_dump_seconds" {
  description = "Memory Dump Seconds"
  type        = string
}