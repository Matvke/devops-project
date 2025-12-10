# Network Load Balancer
resource "yandex_lb_network_load_balancer" "main" {
  name = var.lb_name
  folder_id = var.folder_id

  # Listener для HTTP (порт 80)
  listener {
    name = "http-listener"
    port = 80
    
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # Привязка Target Group с health check
  attached_target_group {
    target_group_id = yandex_lb_target_group.backend.id
    
    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }

  labels = var.tags

  depends_on = [yandex_lb_target_group.backend]
}

resource "yandex_lb_target_group" "backend" {
  name = "backend-tg"
  
  dynamic "target" {
    for_each = yandex_compute_instance_group.backend-vm-group.instances
    
    content {
      subnet_id  = yandex_vpc_subnet.private_app.id
      address = target.value.network_interface[0].ip_address
    }
  }
}
