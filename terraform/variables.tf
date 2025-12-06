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

variable "service_account_key_file" {
  description = "Path to service account key file in JSON format"
  type        = string
  default     = "key.json"
}

variable "bucket_names" {
  description = "Map of bucket names for different purposes"
  type        = map(string)
  default = {
    frontend = "my-frontend-bucket"
    media    = "my-media-bucket"
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