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