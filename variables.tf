# holden:ignore:HLD_TF_027 — single-resource module intentionally exposes the
# resource's own optional attributes (protocol, connect_mode, nfs_export_options,
# performance_config, ...) as variables rather than forcing every caller into
# hardcoded defaults; there is no second responsibility to split out.
variable "kms_key_name" {
  type        = string
  description = "Resource name of the Cloud KMS key used to encrypt the Filestore instance"
  sensitive   = true

  validation {
    condition     = length(trimspace(var.kms_key_name)) > 0
    error_message = "var.kms_key_name must be a non-empty string"
  }
}

variable "network_id" {
  type        = string
  description = "Self link of the VPC network the Filestore instance attaches to"

  validation {
    condition     = length(trimspace(var.network_id)) > 0
    error_message = "var.network_id must be a non-empty string"
  }
}

variable "tier" {
  type        = string
  description = "Tier of the Filestore instance"
  default     = "BASIC_HDD"

  validation {
    condition     = length(trimspace(var.tier)) > 0
    error_message = "var.tier must be a non-empty string"
  }
}

variable "location" {
  type        = string
  description = "Location of the Filestore instance"
  default     = "europe-west2-a"

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "var.location must be a non-empty string"
  }
}

variable "name" {
  type        = string
  description = "Name of the Filestore instance"
  default     = "main"

  validation {
    condition     = length(trimspace(var.name)) > 0
    error_message = "var.name must be a non-empty string"
  }
}

variable "capacity_gb" {
  type        = number
  description = "Capacity of the file share, in GiB"
  default     = 1024

  validation {
    condition     = var.capacity_gb > 0
    error_message = "var.capacity_gb must be greater than 0"
  }
}

variable "file_share_name" {
  type        = string
  description = "Name of the NFS file share exposed by the instance"
  default     = "share1"

  validation {
    condition     = length(trimspace(var.file_share_name)) > 0
    error_message = "var.file_share_name must be a non-empty string"
  }
}

variable "network_modes" {
  type        = list(string)
  description = "IP versions for which the instance has IP addresses reserved"
  default     = ["MODE_IPV4"]

  validation {
    condition     = length(var.network_modes) > 0 && alltrue([for m in var.network_modes : contains(["MODE_IPV4", "MODE_IPV6"], m)])
    error_message = "var.network_modes must be a non-empty list containing only \"MODE_IPV4\" and/or \"MODE_IPV6\""
  }
}

variable "deletion_protection_enabled" {
  type        = bool
  description = "Whether deletion protection is enabled for the Filestore instance"
  default     = true
}

variable "deletion_protection_reason" {
  type        = string
  description = "Reason for enabling/disabling deletion protection, surfaced in the GCP console"
  default     = null

  validation {
    condition     = var.deletion_protection_reason == null || length(trimspace(var.deletion_protection_reason)) > 0
    error_message = "var.deletion_protection_reason must be null or a non-empty string"
  }
}

variable "description" {
  type        = string
  description = "Description of the Filestore instance"
  default     = null

  validation {
    condition     = var.description == null || length(trimspace(var.description)) > 0
    error_message = "var.description must be null or a non-empty string"
  }
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the Filestore instance"
  default     = {}

  validation {
    condition     = alltrue([for k in keys(var.labels) : can(regex("^[a-z][a-z0-9_-]{0,62}$", k))])
    error_message = "var.labels keys must match GCP label key format: lowercase letters, digits, underscores, dashes, starting with a letter, max 63 chars"
  }
}

variable "protocol" {
  type        = string
  description = "File system protocol of the instance"
  default     = "NFS_V3"

  validation {
    condition     = contains(["NFS_V3", "NFS_V4_1"], var.protocol)
    error_message = "var.protocol must be either \"NFS_V3\" or \"NFS_V4_1\""
  }
}

variable "connect_mode" {
  type        = string
  description = "Network connection mode used by the instance"
  default     = "DIRECT_PEERING"

  validation {
    condition     = contains(["DIRECT_PEERING", "PRIVATE_SERVICE_ACCESS"], var.connect_mode)
    error_message = "var.connect_mode must be either \"DIRECT_PEERING\" or \"PRIVATE_SERVICE_ACCESS\""
  }
}

variable "reserved_ip_range" {
  type        = string
  description = "CIDR range, or name of an allocated address range, used when connect_mode is PRIVATE_SERVICE_ACCESS. Leave null for DIRECT_PEERING."
  default     = null

  validation {
    condition     = var.reserved_ip_range == null || length(trimspace(var.reserved_ip_range)) > 0
    error_message = "var.reserved_ip_range must be null or a non-empty string"
  }
}

variable "nfs_export_options" {
  type = list(object({
    ip_ranges   = optional(list(string))
    access_mode = optional(string, "READ_WRITE")
    squash_mode = optional(string, "NO_ROOT_SQUASH")
    anon_uid    = optional(number)
    anon_gid    = optional(number)
  }))
  description = "NFS export access control for the file share. Filestore applies its own default (full read/write access from the entire client network) when this is null; set it explicitly to restrict client IP ranges or access mode."
  default     = null

  validation {
    condition     = var.nfs_export_options == null || alltrue([for o in var.nfs_export_options : contains(["READ_ONLY", "READ_WRITE"], o.access_mode)])
    error_message = "var.nfs_export_options[*].access_mode must be either \"READ_ONLY\" or \"READ_WRITE\""
  }

  validation {
    condition     = var.nfs_export_options == null || alltrue([for o in var.nfs_export_options : contains(["NO_ROOT_SQUASH", "ROOT_SQUASH", "ALL_SQUASH"], o.squash_mode)])
    error_message = "var.nfs_export_options[*].squash_mode must be one of \"NO_ROOT_SQUASH\", \"ROOT_SQUASH\", \"ALL_SQUASH\""
  }
}

variable "performance_config" {
  type = object({
    max_iops_per_tb = number
  })
  description = "IOPS-per-TB performance configuration for tiers that support it (e.g. ENTERPRISE, HIGH_SCALE_SSD) — IOPS scale with provisioned capacity. Leave null for tiers (e.g. BASIC_HDD, BASIC_SSD) that don't support it. Fixed (capacity-independent) IOPS is not exposed by this module to keep it to a single configuration path."
  default     = null

  validation {
    condition     = var.performance_config == null || var.performance_config.max_iops_per_tb > 0
    error_message = "var.performance_config.max_iops_per_tb must be greater than 0"
  }
}