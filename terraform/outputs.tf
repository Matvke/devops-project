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

output "registry_id" {
  value = yandex_container_registry.my-registry.id
}

output "repository_urls" {
  value = [
    "cr.yandex/${yandex_container_repository.kittygram-backend.name}",
    "cr.yandex/${yandex_container_repository.kittygram-database.name}",
    "cr.yandex/${yandex_container_repository.kittygram-frontend.name}",
    "cr.yandex/${yandex_container_repository.kittygram-gateway.name}"
  ]
}

output "backend_repository" {
  description = "URL backend repository"
  value       = "cr.yandex/${yandex_container_repository.kittygram-backend.name}"
}

output "frontend_repository" {
  description = "URL frontend repository"
  value       = "cr.yandex/${yandex_container_repository.kittygram-frontend.name}"
}