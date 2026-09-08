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