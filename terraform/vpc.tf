# Создание VPC сети
resource "yandex_vpc_network" "main" {
  name        = var.vpc_name
  description = var.vpc_description
  labels      = var.tags
}

# Создание интернет-шлюза
resource "yandex_vpc_gateway" "nat_gateway" {
  name = "nat-gateway"
  shared_egress_gateway {}
}

# Создание таблицы маршрутизации для NAT
resource "yandex_vpc_route_table" "private_rt" {
  name       = "private-route-table"
  network_id = yandex_vpc_network.main.id
  labels     = var.tags

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

# Публичная подсеть (для Load Balancer)
resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet"
  description    = "Публичная подсеть для балансировщика нагрузки"
  v4_cidr_blocks = [var.public_subnet_cidr]
  zone           = var.zone
  network_id     = yandex_vpc_network.main.id
  labels         = var.tags
}

# Приватная подсеть для Instance Group
resource "yandex_vpc_subnet" "private_app" {
  name           = "private-app-subnet"
  description    = "Приватная подсеть для backend приложений"
  v4_cidr_blocks = [var.private_app_subnet_cidr]
  zone           = var.zone
  network_id     = yandex_vpc_network.main.id
  route_table_id = yandex_vpc_route_table.private_rt.id
  labels         = var.tags
}

# Группы безопасности
resource "yandex_vpc_security_group" "lb_sg" {
  name        = "load-balancer-sg"
  description = "Security Group для Load Balancer"
  network_id  = yandex_vpc_network.main.id
  labels      = var.tags

  ingress {
    description    = "HTTP"
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description    = "HTTPS"
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description    = "Разрешить все исходящие соединения"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "backend_sg" {
  name        = "backend-sg"
  description = "Security Group для Backend приложений"
  network_id  = yandex_vpc_network.main.id
  labels      = var.tags

  ingress {
    description       = "HTTP от Load Balancer"
    protocol          = "TCP"
    port              = 80
    security_group_id = yandex_vpc_security_group.lb_sg.id
  }

  ingress {
    description       = "HTTPS от Load Balancer"
    protocol          = "TCP"
    port              = 443
    security_group_id = yandex_vpc_security_group.lb_sg.id
  }

  ingress {
    description    = "SSH для администрирования"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["10.0.0.0/8"] # Только из внутренней сети
  }

  egress {
    description    = "Разрешить все исходящие соединения"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
