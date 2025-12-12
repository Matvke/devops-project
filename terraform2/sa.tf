resource "yandex_iam_service_account" "ig_sa" {
  name        = "instance-group-sa"
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "backend_admin" {
  folder_id = var.folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.ig_sa.id}"
}