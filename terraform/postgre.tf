resource "yandex_compute_instance" "postgres_vm" {
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

  network_interface {
    subnet_id = yandex_vpc_subnet.private_app.id
    nat       = false
  }

  metadata = {
    user-data = <<-EOF
      #cloud-config
      runcmd:
        - docker run -d \
          --name postgres \
          -p 5432:5432 \
          -e POSTGRES_PASSWORD=${var.postgres_password} \
          -v /data/postgres:/var/lib/postgresql/data \
          postgres:15-alpine
    EOF
  }
}