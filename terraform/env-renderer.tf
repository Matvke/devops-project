data "template_file" "django_env" {
  template = file(".env.tpl")
  
  vars = {
    debug    = "False"  # В продакшене всегда False
    
    secret_key = var.django_secret_key
    
    allowed_hosts = join(",", concat(
      [ 
        "localhost", 
        "127.0.0.1",
        "*.yandexcloud.app",
        var.domain_name
      ]
    ))
    
    csrf_origins = join(",", [
      for origin in var.csrf_trusted_origins : 
        "https://${origin}"
    ])
    
    db_name     = var.postgres_database
    db_user     = var.postgres_username
    db_password = var.postgres_password
    db_host     = yandex_compute_instance.postgres_vm.network_interface[0].ip_address
    db_port     = "5432"
    
    # CORS - фронтенд адрес
    cors_origins = join(",", [
      for origin in var.frontend_origins : 
        "https://${origin}"
    ])
    
    # S3 credentials
    s3_access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    s3_secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    s3_bucket     = yandex_storage_bucket.media_files.bucket
  }
}
