resource "yandex_vpc_security_group" "db-sg" {
  name       = "postgres-security-group"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 5432
    v4_cidr_blocks = ["192.168.10.0/24"]
  }

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"] # Временно
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "app-sg" {
  name       = "app-security-group"
  network_id = yandex_vpc_network.network.id

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 9000
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
