variable "cloud_id" {
  description = "Yandex Cloud ID where resources will be created"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  default     = "kittygram.com"
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

variable "yc_token" {
  description = "Path to service account key file in JSON format"
  type        = string
  default     = null
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

variable "endpoints_subnet_cidr" {
  type        = string
  description = "CIDR подсети для эндпоинтов"
  default     = "10.0.4.0/24"
}

variable "tags" {
  type        = map(string)
  description = "Теги ресурсов"
  default = {
    project     = "kittygram"
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

variable "instance_group_name" {
  type        = string
  description = "Имя группы вм"
  default     = "backend-vm"
}

variable "platform_id" {
  type        = string
  description = "Версия платформы"
  default     = "standard-v3"
}

variable "image_id" {
  type        = string
  description = "Image id"
  default     = "fd84ocs2qmrnto64cl6m"
}

variable "docker_registry_id" {
  description = "ID Container Registry"
  default     = "crp6qrsugbr2qs16ckd1"
}

variable "docker_backend_image" {
  description = "Backend Docker image name"
  default     = "kittygram-backend"
}

variable "docker_backend_port" {
  description = "Backend container port"
  default     = 8000
}

variable "docker_tag" {
  description = "Backend image tag"
  default     = "latest"
}

variable "username" {
  type        = string
  description = "VM Username"
  default     = "butolin"
}

variable "ssh_key_path" {
  type        = string
  description = "Path to ssh key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "certificate_manager_certificate_id" {
  description = "ID сертификата из Yandex Certificate Manager"
  type        = string
  default     = null
}

variable "lb_name" {
  type        = string
  description = "Load Balancer name"
  default     = "kittygram-lb"
}

variable "registry_name" {
  type        = string
  description = "Container Registry name"
  default     = "kittygram-registry"
}

variable "backend_sa_name" {
  type        = string
  description = "SA name"
  default     = "backend-sa"
}

variable "dotenv_backend" {
  type = string
  description = "Path to .env"
  default = ".env"
}

variable "postgres_database" {
  type        = string
  description = "Имя базы данных PostgreSQL"
  default     = "kittygram"
}

variable "postgres_username" {
  type        = string
  description = "Имя пользователя PostgreSQL"
  default     = "kittygram_user"
}

variable "postgres_password" {
  type        = string
  description = "Пароль PostgreSQL"
  default     = null
}

variable "django_secret_key" {
  type        = string
  description = "Секретный ключ"
  default     = null
}

variable "csrf_trusted_origins" {
  type        = list(string)
  description = "Trusted origins for CSRF protection"
  default     = ["kittygram-frontend.website.yandexcloud.net"]
}

variable "frontend_origins" {
  type        = list(string)
  description = "Frontend origins for CORS"
  default     = ["kittygram-frontend.website.yandexcloud.net"]
}