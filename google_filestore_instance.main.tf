resource "google_filestore_instance" "main" {
  name     = "main"
  location = "europe-west2-a"
  tier     = "BASIC_HDD"

  kms_key_name = var.kms_key_name

  file_shares {
    capacity_gb = 1024
    name        = "share1"
  }

  networks {
    network = var.network_id
    modes   = ["MODE_IPV4"]
  }
}