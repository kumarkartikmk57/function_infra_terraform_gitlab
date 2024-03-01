terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.18.0"
    }
  }
    backend "gcs" {
    bucket  = "cosmic-descent-405605-tfstates"
    prefix  = "terraform/functionconnector"
  }
}

provider "google" {
  project = "cosmic-descent-405605"
}