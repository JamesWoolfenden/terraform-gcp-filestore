resource "google_filestore_instance" "main" {
  name        = var.name
  location    = var.location
  tier        = var.tier
  description = var.description
  labels      = var.labels
  protocol    = var.protocol

  deletion_protection_enabled = var.deletion_protection_enabled
  deletion_protection_reason  = var.deletion_protection_reason

  kms_key_name = var.kms_key_name

  file_shares {
    capacity_gb = var.capacity_gb
    name        = var.file_share_name

    dynamic "nfs_export_options" {
      for_each = local.nfs_export_options
      content {
        ip_ranges   = nfs_export_options.value.ip_ranges
        access_mode = nfs_export_options.value.access_mode
        squash_mode = nfs_export_options.value.squash_mode
        anon_uid    = nfs_export_options.value.anon_uid
        anon_gid    = nfs_export_options.value.anon_gid
      }
    }
  }

  networks {
    network           = var.network_id
    modes             = var.network_modes
    connect_mode      = var.connect_mode
    reserved_ip_range = var.reserved_ip_range
  }

  dynamic "performance_config" {
    for_each = local.performance_config
    content {
      iops_per_tb {
        max_iops_per_tb = performance_config.value.max_iops_per_tb
      }
    }
  }
}
