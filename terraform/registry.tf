# Container Registry для образов
resource "yandex_container_registry" "my-registry" {
  name      = var.registry_name
  folder_id = var.folder_id
  
  labels = {
    project = "kittygram"
    managed-by = "terraform"
  }
}

resource "yandex_container_repository" "kittygram-backend" {
  name = "${yandex_container_registry.my-registry.id}/kittygram-backend"
}

resource "yandex_container_repository" "kittygram-frontend" {
  name = "${yandex_container_registry.my-registry.id}/kittygram-frontend"
}

# Service Account для pull образов из Container Registry
resource "yandex_iam_service_account" "cr_puller" {
  name        = "cr-puller-sa"
  description = "Service account for pulling images from Container Registry"
  folder_id   = var.folder_id
}

# Роль для pull образов
resource "yandex_resourcemanager_folder_iam_member" "cr_puller_role" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.cr_puller.id}"
}
