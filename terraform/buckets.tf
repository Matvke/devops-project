
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
