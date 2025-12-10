DEBUG=${debug}
DJANGO_SECRET_KEY=${secret_key}
ALLOWED_HOSTS=${allowed_hosts}
CSRF_TRUSTED_ORIGINS=${csrf_origins}

# Database
POSTGRES_DB=${db_name}
POSTGRES_USER=${db_user}
POSTGRES_PASSWORD=${db_password}
DB_HOST=${db_host}
DB_PORT=${db_port}

# CORS
CORS_ALLOWED_ORIGINS=${cors_origins}
CORS_ALLOW_CREDENTIALS=True

# Storage
USE_S3=True
AWS_ACCESS_KEY_ID=${s3_access_key}
AWS_SECRET_ACCESS_KEY=${s3_secret_key}
AWS_STORAGE_BUCKET_NAME=${s3_bucket}
AWS_S3_ENDPOINT_URL=https://storage.yandexcloud.net
AWS_S3_REGION_NAME=ru-central1