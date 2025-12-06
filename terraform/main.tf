terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 1.14.0"
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
  service_account_key_file = var.service_account_key_file
}

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

# Создание статического бакета для фронтенда
resource "yandex_storage_bucket" "frontend_static" {
  bucket = var.bucket_names["frontend"]

  # Для статического сайта
  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  # Настройки CORS для веб-приложения
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_origins = ["https://your-domain.com", "http://localhost:3000"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  # Теги
  tags = var.bucket_tags["frontend"]
}

# Грант на публичный доступ к фронтенд бакету (для статического сайта)
resource "yandex_storage_bucket_grant" "frontend_public" {
  bucket = yandex_storage_bucket.frontend_static.bucket
  
  # Доступ для всех пользователей (публичный доступ для чтения)
  grant {
    uri         = "http://acs.amazonaws.com/groups/global/AllUsers"
    permissions = ["READ"]
    type        = "Group"
  }
}

# Создание бакета для медиа файлов
resource "yandex_storage_bucket" "media_files" {
  bucket = var.bucket_names["media"]

  # Более строгий CORS для медиа
  cors_rule {
    allowed_headers = ["Authorization", "Content-Type"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["https://your-app.com", "http://localhost:3000"]
    max_age_seconds = 3600
  }

  tags = var.bucket_tags["media"]

  force_destroy = false
}

# Грант для сервисного аккаунта на полный доступ к медиа бакету
resource "yandex_storage_bucket_grant" "media_sa_access" {
  bucket = yandex_storage_bucket.media_files.bucket
  
  grant {
    id          = yandex_iam_service_account.storage-sa.id
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
}

# Дополнительный грант для текущего пользователя
resource "yandex_storage_bucket_grant" "current_user_media_access" {
  count = var.grant_current_user_access && var.current_user_id != null ? 1 : 0
  
  bucket = yandex_storage_bucket.media_files.bucket
  
  grant {
    id          = var.current_user_id
    permissions = ["FULL_CONTROL"]
    type        = "CanonicalUser"
  }
}

# роль для чтения объектов
resource "yandex_resourcemanager_folder_iam_member" "storage_viewer" {
  count = var.grant_viewer_access ? 1 : 0

  folder_id = var.folder_id
  role      = "storage.viewer"
  member    = "serviceAccount:${yandex_iam_service_account.storage-sa.id}"
}
