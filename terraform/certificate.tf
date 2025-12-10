# Yandex Certificate Manager
data "yandex_cm_certificate" "main" {
  count = var.certificate_manager_certificate_id != null ? 1 : 0
  
  certificate_id = var.certificate_manager_certificate_id
}