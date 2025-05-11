variable "name" {
  description = "Name to be used on all resources as prefix"
  type        = string
  default     = "transit-gateway"
}

variable "environment" {
  description = "Environment for the transit gateway"
  type        = string
  default     = "production"
}

variable "vpc2_cidr" {
  description = "CIDR block for Developer VPC2"
  type        = string
}

variable "vpc3_cidr" {
  description = "CIDR block for Services VPC3"
  type        = string
}

variable "datacenter_cidr" {
  description = "CIDR block for Data Center in Ireland"
  type        = string
}

# modules/transit_gateway/outputs.tf

output "tgw_id" {
  description = "ID of the created Transit Gateway"
  value       = aws_ec2_transit_gateway.this.id
}

output "vpc_route_table_id" {
  description = "ID of the VPC route table in Transit Gateway"
  value       = aws_ec2_transit_gateway_route_table.vpc.id
}

output "direct_connect_route_table_id" {
  description = "ID of the Direct Connect route table in Transit Gateway"
  value       = aws_ec2_transit_gateway_route_table.direct_connect.id
}

output "vpn_route_table_id" {
  description = "ID of the VPN route table in Transit Gateway"
  value       = aws_ec2_transit_gateway_route_table.vpn.id
}

output "prefix_list_id" {
  description = "ID of the prefix list for VPC CIDRs"
  value       = aws_ec2_managed_prefix_list.vpc_cidrs.id
}