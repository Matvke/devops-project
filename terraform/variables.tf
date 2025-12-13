variable "cloud_id" {
  type        = string
  sensitive   = true
}

variable "folder_id" {
  type        = string
  sensitive   = true
}

variable "zone" {
  type        = string
  default     = "ru-central1-a"
}

variable "service_account_key_file" {
  description = "Path to service account key file in JSON format"
  type        = string
  default     = "key.json"
}

variable "ssh_key" {
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "db_password" {
  type        = string
  sensitive     = true
}

variable "django_secret_key" {
  type        = string
  sensitive     = true
}