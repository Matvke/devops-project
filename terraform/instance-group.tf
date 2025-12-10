# Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "backend-role-images-puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.backend.id}"
}

# Создание Instance Group

resource "yandex_compute_instance_group" "backend-vm-group" {
  name               = "kittygram-backend"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.backend.id
  
  instance_template {
    platform_id = "standard-v3"
    resources {
      cores  = 2
      memory = 2
    }

    boot_disk {
      initialize_params {
        image_id = var.image_id 
        size     = 20
      }
    }

    network_interface {
      subnet_ids = ["${yandex_vpc_subnet.private_app.id}"]
      nat       = true
    }

    metadata = {
      serial-port-enable = 1
      user-data          = <<-EOF
        #cloud-config
        users:
          - name: ubuntu
            groups: sudo
            shell: /bin/bash
            sudo: 'ALL=(ALL) NOPASSWD:ALL'
            ssh-authorized-keys:
              - ${file(var.ssh_key_path)}

        runcmd:
          - mkdir -p /app/
          - chown -R ubuntu:ubuntu /app

        write_files:
          - path: /app/.env
            owner: ubuntu:ubuntu
            permissions: '0600'  # только владелец
            content: |
              ${indent(14, data.template_file.django_env.rendered)}

        packages:
          - docker.io
          - docker-compose
          - postgresql-client-15
        
        runcmd:
          - systemctl enable docker
          - systemctl start docker

          - export YC_TOKEN=$(yc iam create-token)
          - echo $YC_TOKEN | docker login --username oauth --password-stdin cr.yandex
          
          # Проверка БД
          - echo "Waiting for database..."
          - source /app/.env
          - export PGPASSWORD="$POSTGRES_PASSWORD"
          - until psql -h "$DB_HOST" -p "$DB_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT 1;" &>/dev/null; do
              echo "Database not ready, waiting..."
              sleep 5
            done
          
          # Запуск
          - docker pull cr.yandex/${var.docker_registry_id}/${var.docker_backend_image}:${var.docker_tag}
          - docker run -d \
              --name kittygram-backend \
              --env-file /app/.env \
              -p 8000:8000 \
              -v /app/media:/app/media \
              -v /app/static:/app/static \
              cr.yandex/${var.docker_registry_id}/${var.docker_backend_image}:${var.docker_tag}
          
          # Логи
          - docker logs --tail 100 kittygram-backend > /var/log/docker-backend.log
      EOF
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }
  allocation_policy {
    zones = ["${var.zone}"]
  }
  deploy_policy {
    max_expansion = 2
    max_unavailable    = 2
  }
}