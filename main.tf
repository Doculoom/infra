provider "google" {
  project = var.project_id
  region  = var.region
}

module "vault" {
  source = "./modules/vault"
  project_id = var.project_id
  region     = var.region
}