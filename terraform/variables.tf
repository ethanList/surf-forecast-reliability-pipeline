variable "project_id" {
  description = "GCP Project ID"
  type        = string
  default     = "surf-forecast-pipeline"
}


variable "location" {
  description = "Location ID for GCP"
  type        = string
  default     = "us-west1"
}

variable "dataset_id" {
  description = "dataset ID for BQ table"
  type        = string
  default     = "surf_forecast_pipeline_raw"
}