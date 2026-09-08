# holden:ignore:HLD_TF_026 — examples intentionally use ../../ to reference the local module root
# holden:ignore:HLD_TF_065 -
module "filestore" {
  source       = "../../"
  kms_key_name = google_kms_crypto_key.filestore.id
  network_id   = google_compute_network.filestore.id

  depends_on = [google_kms_crypto_key_iam_member.filestore]
}
