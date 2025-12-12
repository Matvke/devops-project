resource "yandex_compute_instance" "postgres-vm" {
  name        = "postgres-vm"
  platform_id = "standard-v3"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8vmcue7aajpmeo39kk" 
      size     = 20
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true # Временно
    ip_address = "192.168.10.10"
    security_group_ids = [yandex_vpc_security_group.db-sg.id]
  }

  metadata = {
    user-data = file("${path.module}/user-data/db-vm.yaml")
  }

}
