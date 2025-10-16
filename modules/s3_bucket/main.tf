resource "aws_s3_bucket" "static_website_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}


resource "aws_s3_bucket_public_access_block" "remote_state_public_access" {
  bucket = aws_s3_bucket.static_website_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket_server_side_encryption_configuration" "remote_state_encryption" {
  bucket = aws_s3_bucket.static_website_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


resource "aws_s3_bucket_versioning" "remote_state_versioning" {
  bucket = aws_s3_bucket.static_website_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_lifecycle_configuration" "remote_state_lifecycle" {
  bucket = aws_s3_bucket.static_website_bucket.id

  rule {
    id     = "noncurrent-cleanup"
    status = "Enabled"

    filter { prefix = "" }

    noncurrent_version_expiration {
      noncurrent_days = var.noncurrent_days
    }

    expiration {
      expired_object_delete_marker = true
    }
  }
}

# Define a mapping of file extensions to content types
locals {
  content_type = {
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "gif"  = "image/gif"
  }
}

#Adding bucket object

resource "aws_s3_object" "website_files" {
  for_each = fileset(var.website_content_path, "**")
  
  bucket = aws_s3_bucket.static_website_bucket.id
  key    = each.value
  source = "${var.website_content_path}/${each.value}"

  # --- LOGIC FOR CONTENT-TYPE ---
  content_type = lookup(
    local.content_type, 
    # Use regex to reliably get the file extension.
    # This captures the characters after the last dot in the filename.
    regex("\\.([^.]+)$", each.value)[0], 
    "binary/octet-stream"
  )

  source_hash = filesha256("${var.website_content_path}/${each.value}")
}
