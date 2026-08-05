resource "google_kms_key_ring" "filestore" {
  name     = "filestore-keyring"
  location = "europe-west2"
}

resource "google_kms_crypto_key" "filestore" {
  name     = "filestore-key"
  key_ring = google_kms_key_ring.filestore.id

  # Ensure automatic rotation is configured (e.g. 30 days)
  rotation_period = "2592000s"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service_identity" "filestore" {
  provider = google-beta
  service  = "file.googleapis.com"
}

resource "google_kms_crypto_key_iam_member" "filestore" {
  crypto_key_id = google_kms_crypto_key.filestore.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.filestore.email}"
}

# holden:ignore:HLD_GCP_094
# holden:ignore:HLD_GCP_303
resource "google_compute_network" "filestore" {
  name                    = "filestore-network"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "filestore" {
  name    = "filestore-firewall"
  network = google_compute_network.filestore.name

  log_config {
    metadata = "INCLUDE_ALL_METADATA"
  }

  allow {
    protocol = "tcp"
    ports    = ["111", "635", "2049", "3049"]
  }

  allow {
    protocol = "udp"
    ports    = ["111", "635", "2049", "3049"]
  }

  source_ranges = ["10.0.0.0/8"]
}

# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
# holden:ignore:HLD_TF_065 - 
module "filestore" {
  source       = "../../"
  kms_key_name = google_kms_crypto_key.filestore.id
  network_id   = google_compute_network.filestore.id
}
