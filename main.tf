# Enable required APIs for Cloud Run, Eventarc, Pub/Sub, and Firestore
resource "google_project_service" "run" {
  project            = var.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "cloudscheduler" {
  project            = var.project_id
  service            = "cloudscheduler.googleapis.com"
  disable_on_destroy = false
}

# Service account for Cloud Run services
resource "google_service_account" "cloud_run_sa" {
  project      = var.project_id
  account_id   = "${var.name}-cr-sa"
  display_name = "${var.name} Cloud Run Service Account"
}

# TODO: Deploy the Cloud Run instance as well as the schedule for the job to run once a daycheck "name" {
