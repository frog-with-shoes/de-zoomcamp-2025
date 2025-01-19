

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.16.0"
    }
  }
}

provider "google" {
  credentials = "./keys/my-creds.json"
  project     = "feisty-parity-448216-i7"
  region      = "us-central1"
}


resource "google_storage_bucket" "demo-bucket" {
  name          = "feisty-parity-448216-i7-terra-bucket"
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "Delete"
    }
  }
}