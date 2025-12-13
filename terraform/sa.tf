resource "yandex_iam_service_account" "ig_sa" {
  name        = "instance-group-sa"
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "backend_admin" {
  folder_id = var.folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.ig_sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "cr_puller" {
  folder_id = var.folder_id
  role      = "container-registry.images.puller"
  member    = "serviceAccount:${yandex_iam_service_account.ig_sa.id}"
}