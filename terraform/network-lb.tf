resource "yandex_lb_network_load_balancer" "app-nlb" {
  name = "app-load-balancer"

  listener {
    name = "app-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.app-group.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/health/api/"
      }
    }
  }
}