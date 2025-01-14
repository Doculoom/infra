variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "doculoom-446020"
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "gemini_key" {
  description = "Gemini Key"
  type        = string
}