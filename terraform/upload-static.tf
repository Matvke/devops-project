locals {
  build_dir = "../frontend/build"
}

resource "yandex_storage_object" "all_static_files" {
  for_each = fileset(local.build_dir, "**/*")
  
  bucket = yandex_storage_bucket.frontend_static.bucket
  key    = each.value
  source = "${local.build_dir}/${each.value}"
  
  content_type = lookup({
    ".html" = "text/html",
    ".css"  = "text/css",
    ".js"   = "application/javascript",
    ".json" = "application/json",
    ".png"  = "image/png",
    ".jpg"  = "image/jpeg",
    ".ico"  = "image/x-icon"
  }, regex("\\.[^.]+$", each.value), "binary/octet-stream")
  
  acl = "public-read"
}