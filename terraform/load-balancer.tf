resource "yandex_alb_backend_group" "static" {
  name = "static-group"
  
  http_backend {
    name = "static"
    
    storage_bucket = yandex_storage_bucket.media_files.bucket
  }
}

resource "yandex_alb_backend_group" "frontend" {
  name = "frontend-group"
  
  http_backend {
    name = "static"
    storage_bucket = yandex_storage_bucket.frontend_static.bucket
  }
}

resource "yandex_alb_backend_group" "api" {
  name = "api-group"
  
  http_backend {
    name = "api"
    port = 3000
    
    target_group_ids = [yandex_compute_instance_group.backend-vm-group.load_balancer[0].target_group_id]
    
    healthcheck {
      timeout  = "10s"
      interval = "1s"
      http_healthcheck {
        path = "/api"
      }
    }
  }
}