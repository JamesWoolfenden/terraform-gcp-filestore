variable "kms_key_name" {
  type        = string
  description = "Resource name of the Cloud KMS key used to encrypt the Filestore instance"

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