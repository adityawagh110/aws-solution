# modules/vpn/outputs.tf

output "customer_gateway_id" {
  description = "ID of the created Customer Gateway"
  value       = aws_customer_gateway.this.id
}

output "vpn_connection_id" {
  description = "ID of the created Site-to-Site VPN connection"
  value       = aws_vpn_connection.this.id
}

output "vpn_attachment_id" {
  description = "ID of the VPN attachment to the Transit Gateway"
  value       = aws_vpn_connection.this.transit_gateway_attachment_id
}

output "tunnel1_address" {
  description = "Public IP address for the first VPN tunnel"
  value       = aws_vpn_connection.this.tunnel1_address
}

output "tunnel2_address" {
  description = "Public IP address for the second VPN tunnel"
  value       = aws_vpn_connection.this.tunnel2_address
}