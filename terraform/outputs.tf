output "frontend_bucket_name" {
  description = "Frontend static bucket name"
  value       = yandex_storage_bucket.frontend_static.bucket
}

output "frontend_bucket_website_endpoint" {
  description = "Website endpoint for frontend bucket"
  value       = yandex_storage_bucket.frontend_static.website_endpoint
}

output "media_bucket_name" {
  description = "Media files bucket name"
  value       = yandex_storage_bucket.media_files.bucket
}

output "service_account_access_key" {
  description = "Service Account Access Key ID"
  value       = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  sensitive   = true
}

output "service_account_secret_key" {
  description = "Service Account Secret Access Key"
  value       = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  sensitive   = true
}

output "buckets_info" {
  description = "Information about created buckets"
  value = {
    frontend = {
      name           = yandex_storage_bucket.frontend_static.bucket
      domain         = yandex_storage_bucket.frontend_static.website_endpoint
      versioning     = try(yandex_storage_bucket.frontend_static.versioning[0].enabled, false)
    }
    media = {
      name       = yandex_storage_bucket.media_files.bucket
      versioning = try(yandex_storage_bucket.media_files.versioning[0].enabled, false)
    }
  }
}