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

# holden:ignore:HLD_GCP_094
# holden:ignore:HLD_GCP_303
resource "google_compute_network" "filestore" {
  name                    = "filestore-network"
  auto_create_subnetworks = false
}

# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
module "filestore" {
  source       = "../../"
  kms_key_name = google_kms_crypto_key.filestore.id
  network_id   = google_compute_network.filestore.id
}
