locals {
  nfs_export_options = coalesce(var.nfs_export_options, [])
  performance_config = var.performance_config == null ? [] : [var.performance_config]
}
