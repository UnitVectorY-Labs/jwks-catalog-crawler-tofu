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

# Grant Cloud Run the ability to publish
resource "google_pubsub_topic_iam_member" "response" {
  project = var.project_id
  topic   = var.http_response_collector_pubsub_topic_name
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

locals {
  final_artifact_registry_project_id = coalesce(var.artifact_registry_project_id, var.project_id)
}

resource "google_cloud_run_v2_job" "default" {
  project  = var.project_id
  location = var.region
  name     = var.name

  deletion_protection = false

  template {

    parallelism = 1
    task_count  = 1

    template {

      service_account = google_service_account.cloud_run_sa.email

      timeout = "600s"

      max_retries = 0

      containers {
        image = "${var.artifact_registry_host}/${local.final_artifact_registry_project_id}/${var.artifact_registry_name}/unitvectory-labs/jwks-catalog-crawler:${var.jwks_catalog_crawler_tag}"

        env {
          name  = "YAML_CATALOG_URL"
          value = var.jwks_catalog_url
        }
        env {
          name  = "GCP_PROJECT_ID"
          value = var.project_id
        }
        env {
          name  = "PUBSUB_TOPIC_NAME"
          value = var.http_response_collector_pubsub_topic_name
        }
      }
    }
  }
}

# Service account for Cloud Run services
resource "google_service_account" "schedule_sa" {
  project      = var.project_id
  account_id   = "${var.name}-sc-sa"
  display_name = "${var.name} Schedule Service Account"
}

resource "google_cloud_run_v2_job_iam_member" "invoke_permission" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_job.default.name
  role     = "roles/run.jobsExecutor"
  member   = "serviceAccount:${google_service_account.schedule_sa.email}"
}

resource "google_cloud_scheduler_job" "run_daily_job" {
  name        = "${var.name}-job-runner"
  project     = var.project_id
  region      = var.region
  schedule    = "0 1 * * *" # Runs daily at 1 AM
  description = "Trigger Cloud Run job ${var.name} daily"

  http_target {
    uri = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs/${var.name}:run"

    http_method = "POST"

    oauth_token {
      service_account_email = google_service_account.schedule_sa.email
    }
  }
}

