provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

module "vault" {
  source     = "./modules/vault"
  project_id = var.project_id
  region     = var.region
  gemini_key = var.gemini_key
}

module "her" {
  source     = "./modules/her"
  project_id = var.project_id
  region     = var.region
  gemini_key = var.gemini_key
  telegram_key = var.telegram_key
  vault_api_url = var.vault_api_url
  service_account_email = var.service_account_email
  her_api_url = var.her_api_url
  google_api_key = var.google_api_key
}
