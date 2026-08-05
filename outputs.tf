output "instance_id" {
  value       = google_filestore_instance.main.id
  description = "ID of the Filestore instance"
}

output "name" {
  value       = google_filestore_instance.main.name
  description = "Name of the Filestore instance"
}

output "ip_addresses" {
  value       = google_filestore_instance.main.networks[0].ip_addresses
  description = "IP addresses of the Filestore instance, for NFS mount targets"
}

output "instance" {
  value       = google_filestore_instance.main
  description = "The full Filestore instance resource"
  sensitive   = true
}
