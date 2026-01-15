output "endpoint" {
  description = "DocumentDB cluster endpoint"
  value       = var.cluster_endpoint
  sensitive   = true
}

output "reader_endpoint" {
  description = "DocumentDB cluster reader endpoint"
  value       = var.reader_endpoint
  sensitive   = true
}

output "port" {
  description = "DocumentDB cluster port"
  value       = var.port
}

