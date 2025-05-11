# modules/tgw_route_tables/outputs.tf

output "vpc2_route_table_id" {
  description = "ID of the Transit Gateway route table for VPC2"
  value       = aws_ec2_transit_gateway_route_table.vpc2.id
}

output "vpc3_route_table_id" {
  description = "ID of the Transit Gateway route table for VPC3"
  value       = aws_ec2_transit_gateway_route_table.vpc3.id
}

output "direct_connect_route_table_id" {
  description = "ID of the Transit Gateway route table for Direct Connect"
  value       = aws_ec2_transit_gateway_route_table.direct_connect.id
}

output "vpn_route_table_id" {
  description = "ID of the Transit Gateway route table for VPN"
  value       = aws_ec2_transit_gateway_route_table.vpn.id
}