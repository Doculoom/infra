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
