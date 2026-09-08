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

