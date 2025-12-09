variable "cloud_id" {
  description = "Yandex Cloud ID where resources will be created"
  type        = string
  sensitive   = true
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
  sensitive   = true
}

variable "zone" {
  type        = string
  description = "Зона доступности"
  default     = "ru-central1-a"
}

variable "service_account_key_file" {
  description = "Path to service account key file in JSON format"
  type        = string
  default     = "key.json"
}

variable "bucket_names" {
  description = "Map of bucket names for different purposes"
  type        = map(string)
  default = {
    frontend = "frontend-bucket"
    media    = "media-bucket"
  }
}

variable "bucket_tags" {
  description = "Tags for buckets"
  type        = map(map(string))
  default = {
    frontend = {
      environment = "production"
      purpose     = "static-website"
    }
    media = {
      environment = "production"
      purpose     = "user-uploads"
    }
  }
}

variable "grant_current_user_access" {
  description = "Whether to grant access to current user"
  type        = bool
  default     = false
}

variable "current_user_id" {
  description = "Yandex Cloud user ID for additional access (optional)"
  type        = string
  default     = null
}

variable "grant_viewer_access" {
  description = "Whether to grant viewer access to service account"
  type        = bool
  default     = false
}

variable "vpc_name" {
  type        = string
  description = "Имя VPC сети"
  default     = "main-network"
}

variable "vpc_description" {
  type        = string
  description = "Описание VPC сети"
  default     = "Основная сеть для приложения"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR публичной подсети"
  default     = "10.0.1.0/24"
}

variable "private_app_subnet_cidr" {
  type        = string
  description = "CIDR приватной подсети приложений"
  default     = "10.0.2.0/24"
}

variable "private_db_subnet_cidr" {
  type        = string
  description = "CIDR приватной подсети БД"
  default     = "10.0.3.0/24"
}

variable "endpoints_subnet_cidr" {
  type        = string
  description = "CIDR подсети для эндпоинтов"
  default     = "10.0.4.0/24"
}

variable "tags" {
  type        = map(string)
  description = "Теги ресурсов"
  default = {
    project     = "myapp"
    environment = "production"
    managed-by  = "terraform"
  }
}

variable "backend_service_account_name" {
  type        = string
  description = "Имя service account для backend"
  default     = "sa-backend"
}

variable "postgres_service_account_name" {
  type        = string
  description = "Имя service account для PostgreSQL"
  default     = "sa-postgres"
}

variable "lockbox_secret_name" {
  type        = string
  description = "Имя секрета в Lockbox"
  default     = "db-credentials"
}
