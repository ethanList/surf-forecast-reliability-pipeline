resource "google_storage_bucket" "forecast_pipe" {
  name          = "surf-forecast-pipeline-raw"
  location      = var.location
  force_destroy = true
}

resource "google_bigquery_dataset" "bq_forecast_pipe" {
  dataset_id = var.dataset_id
  location   = var.location
  description = "Raw NOAA forecast snapshots for surf spots" 
}

resource "google_bigquery_table" "forecast_raw" {
  dataset_id = var.dataset_id
  table_id   = "forecast_info"

  schema = <<EOF
[
  {"name": "spot_name", "type": "STRING", "mode": "NULLABLE"},
  {"name": "spot_id", "type": "STRING", "mode": "NULLABLE"},
  {"name": "wave_height", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "swell_period_primary", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "swell_period_secondary", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "swell_height_primary", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "swell_height_secondary", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "swell_direction_primary", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "swell_direction_secondary", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "wave_direction", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "wind_direction", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "wind_strength_kts", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "latitude", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "longitude", "type": "FLOAT", "mode": "NULLABLE"},
  {"name": "time_pulled", "type": "TIMESTAMP", "mode": "NULLABLE"},
  {"name": "generated_at", "type": "TIMESTAMP", "mode": "NULLABLE"},
  {"name": "target_date", "type": "TIMESTAMP", "mode": "NULLABLE"}
]
EOF
}


resource "google_service_account" "ingestion_service_acct" {
  account_id   = "surf-ingestion"
  display_name = "Surf pipeline ingestion service account"
}


resource "google_project_iam_member" "storage_writer" {
  project = var.project_id
  role    = "roles/storage.objectCreator"
  member  = "serviceAccount:${google_service_account.ingestion_service_acct.email}"
}

resource "google_project_iam_member" "bigquery_writer" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.ingestion_service_acct.email}"
}