# Внутренняя DNS зона в VPC
resource "yandex_dns_zone" "internal-zone" {
  name        = "internal-zone"
  description = "Internal DNS zone for application"
  zone        = "app.internal."
  public      = false 
  
  private_networks {
    network_id = yandex_vpc_network.private_app.id
  }
}

# Запись для ALB
resource "yandex_dns_recordset" "app" {
  zone_id = yandex_dns_zone.internal-zone.id
  name    = "kittygram.app.internal."
  type    = "A"
  ttl     = 300
  data    = ["10.0.1.100"]
}

# Запись для API
resource "yandex_dns_recordset" "api" {
  zone_id = yandex_dns_zone.internal-zone.id
  name    = "api.app.internal."
  type    = "A"
  ttl     = 300
  data    = ["10.0.1.100"]
}

resource "yandex_dns_recordset" "media" {
  zone_id = yandex_dns_zone.internal-zone.id
  name    = "media.app.internal."
  type    = "CNAME"
  ttl     = 300
  data    = ["${yandex_storage_bucket.media_files.bucket}.storage.yandexcloud.net."]
}