# Container Registry для образов
resource "yandex_container_registry" "my-registry" {
  name      = "project"
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
