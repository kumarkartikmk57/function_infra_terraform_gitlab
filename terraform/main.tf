data "terraform_remote_state" "base" {
  backend = "gcs"
  config = {
    bucket  = "cosmic-descent-405605-tfstates"
    prefix  = "terraform/connector"
  }
}

resource "google_storage_bucket" "bucket" {
  name     = "cosmic-descent-405605-function-storage"
  location = "EU"
}

# Archive a single file.

data "archive_file" "init" {
  type        = "zip"
  source_dir = "../src"
  output_path = "${var.file}"
}

resource "google_storage_bucket_object" "archive" {
  name   = var.file
  bucket = google_storage_bucket.bucket.name
  source = var.file
}

resource "google_cloudfunctions_function" "function" {
  name        = "function-test"
  description = "My function"
  runtime     = "python39"
  region = var.region

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  vpc_connector = data.terraform_remote_state.base.outputs.connector_id
  entry_point = "hello_http"
}
