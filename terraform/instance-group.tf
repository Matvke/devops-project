resource "yandex_compute_instance_group" "app-group" {
  name               = "app-instance-group"
  service_account_id = yandex_iam_service_account.ig_sa.id
  
  instance_template {
    platform_id = "standard-v3"
    
    resources {
      cores  = 2
      memory = 4
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd8emvfmfoaordspe1jr"
        size     = 30
      }
    }

    scheduling_policy {
        preemptible = true
    }

    network_interface {
      network_id = yandex_vpc_network.network.id
      subnet_ids = [yandex_vpc_subnet.subnet.id]
      nat        = true
      security_group_ids = [yandex_vpc_security_group.app-sg.id]
    }

    metadata = {
      user-data = templatefile("${path.module}/user-data/app-vm.yaml", {
        db_host = yandex_compute_instance.postgres-vm.network_interface.0.ip_address
        db_password = var.db_password
        django_secret_key = var.django_secret_key
      })
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  load_balancer {
    target_group_name = "app-target-group"
  }

  depends_on = [
    yandex_compute_instance.postgres-vm,
    yandex_vpc_security_group.db-sg,
    yandex_vpc_security_group.app-sg,
    yandex_vpc_subnet.subnet
    ]
}