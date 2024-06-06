provider "google" {
  project = "regal-extension-425019-n0"
  region  = "us-central1"
  zone    = "us-central1-c"
}

provider "google-beta" {
  project = "regal-extension-425019-n0"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_storage_bucket" "website" {
  provider = google
  name     = "grupo25-website"
  location = "US"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  labels = {
    allow_public_bucket_acl = "true"
  }

  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["Content-Type"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_object" "index" {
  name         = "index.html"
  source       = "index.html"
  bucket       = google_storage_bucket.website.name
  content_type = "text/html"
}

resource "google_storage_bucket_object" "error" {
  name         = "404.html"
  source       = "error.html"
  bucket       = google_storage_bucket.website.name
  content_type = "text/html"
}

# Make new objects public
resource "google_storage_bucket_iam_member" "viewers" {
  bucket = google_storage_bucket.website.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
  depends_on = [
    google_storage_bucket_object.index,
    google_storage_bucket_object.error
  ]
}

# Reserve an external IP
resource "google_compute_global_address" "website" {
  provider = google
  name     = "website-lb-ip"
}

data "google_dns_managed_zone" "gcp_grupo25_dev" {
  name = "gcp-grupo-25-com"
}

# Add the IP to the DNS
resource "google_dns_record_set" "website" {
  provider     = google
  name         = "web.${data.google_dns_managed_zone.gcp_grupo25_dev.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = data.google_dns_managed_zone.gcp_grupo25_dev.name
  rrdatas      = [google_compute_global_address.website.address]
}

# Add the bucket as a CDN backend
resource "google_compute_backend_bucket" "website" {
  provider    = google
  name        = "website-backend"
  description = "Contains files needed by the website"
  bucket_name = google_storage_bucket.website.name
  enable_cdn  = true
}

# Create HTTPS certificate
resource "google_compute_managed_ssl_certificate" "website" {
  provider = google-beta
  name     = "website-cert"
  managed {
    domains = [google_dns_record_set.website.name]
  }
}

# GCP URL MAP
resource "google_compute_url_map" "website" {
  provider        = google
  name            = "website-url-map"
  default_service = google_compute_backend_bucket.website.self_link
}

# GCP target proxy
resource "google_compute_target_https_proxy" "website" {
  provider         = google
  name             = "website-target-proxy"
  url_map          = google_compute_url_map.website.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.website.self_link]
}

# GCP forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  provider              = google
  name                  = "website-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_address            = google_compute_global_address.website.address
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.website.self_link
}