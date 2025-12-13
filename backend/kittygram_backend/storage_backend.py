from django.conf import settings
from storages.backends.s3boto3 import S3Boto3Storage


class StaticStorage(S3Boto3Storage):
    location = 'media'
    default_acl = getattr(settings, 'AWS_DEFAULT_ACL', 'private')
    file_overwrite = getattr(settings, 'AWS_S3_FILE_OVERWRITE', False)
    custom_domain = False


class MediaStorage(S3Boto3Storage):
    location = 'media'
    default_acl = getattr(settings, 'AWS_DEFAULT_ACL', 'private')
    file_overwrite = getattr(settings, 'AWS_S3_FILE_OVERWRITE', False)
    custom_domain = False
