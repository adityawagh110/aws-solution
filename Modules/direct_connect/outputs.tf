output "dx_connection_id" {
  description = "ID of the created Direct Connect connection"
  value       = aws_dx_connection.this.id
}

output "dx_gateway_id" {
  description = "ID of the created Direct Connect gateway"
  value       = aws_dx_gateway.this.id
}

output "dx_gateway_attachment_id" {
  description = "ID of the Direct Connect gateway association with Transit Gateway"
  value       = aws_dx_gateway_association.this.id
}

output "dx_private_vif_id" {
  description = "ID of the Direct Connect private virtual interface"
  value       = aws_dx_private_virtual_interface.this.id
}