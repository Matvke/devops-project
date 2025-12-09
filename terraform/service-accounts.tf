# Сервисный аккаунт для работы с Object Storage
resource "yandex_iam_service_account" "storage-sa" {
  name        = "storage-service-account"
  description = "Service account for managing Object Storage"
  folder_id   = var.folder_id
}

# Статические ключи доступа для сервисного аккаунта
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.storage-sa.id
  description        = "Static access key for Object Storage management"
}

# Роль на запись в бакеты
resource "yandex_resourcemanager_folder_iam_member" "storage-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.storage-sa.id}"
}

# Сервисный аккаунт для backend приложения
resource "yandex_iam_service_account" "backend" {
  name        = var.backend_service_account_name
  description = "Service account для backend приложения"
  folder_id   = var.folder_id
}

# Роли для backend SA
resource "yandex_resourcemanager_folder_iam_member" "backend_storage_uploader" {
  folder_id = var.folder_id
  role      = "storage.uploader"
  member    = "serviceAccount:${yandex_iam_service_account.backend.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "backend_storage_viewer" {
  folder_id = var.folder_id
  role      = "storage.viewer"
  member    = "serviceAccount:${yandex_iam_service_account.backend.id}"
}

# роль для чтения объектов
resource "yandex_resourcemanager_folder_iam_member" "storage_viewer" {
  count = var.grant_viewer_access ? 1 : 0

  folder_id = var.folder_id
  role      = "storage.viewer"
  member    = "serviceAccount:${yandex_iam_service_account.storage-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "backend_lockbox_viewer" {
  folder_id = var.folder_id
  role      = "lockbox.payloadViewer"
  member    = "serviceAccount:${yandex_iam_service_account.backend.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "backend_logging_writer" {
  folder_id = var.folder_id
  role      = "logging.writer"
  member    = "serviceAccount:${yandex_iam_service_account.backend.id}"
}

# Мониторинг роли для backend:
resource "yandex_resourcemanager_folder_iam_member" "backend_monitoring_editor" {
  folder_id = var.folder_id
  role      = "monitoring.editor"
  member    = "serviceAccount:${yandex_iam_service_account.backend.id}"
}

# Service Account для PostgreSQL 
resource "yandex_iam_service_account" "postgres" {
  name        = var.postgres_service_account_name
  description = "Service account для PostgreSQL"
  folder_id   = var.folder_id
}

# PostgreSQL в контейнере
resource "yandex_resourcemanager_folder_iam_member" "postgres_container_minimal" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.postgres.id}"
}

# Static keys для backend (если нужно для S3)
resource "yandex_iam_service_account_static_access_key" "backend_s3" {
  service_account_id = yandex_iam_service_account.backend.id
  description        = "Static key for S3 access from backend"
}
