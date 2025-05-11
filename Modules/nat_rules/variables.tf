
variable "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  type        = string
}

variable "vpc2_attachment_id" {
  description = "ID of the VPC2 attachment to Transit Gateway"
  type        = string
}

variable "vpc3_attachment_id" {
  description = "ID of the VPC3 attachment to Transit Gateway"
  type        = string
}

variable "vpc2_to_vpc3_source_cidr" {
  description = "Source CIDR block for VPC2 to VPC3 NAT rules"
  type        = string
}

variable "vpc2_to_vpc3_translated_cidr" {
  description = "Translated CIDR block for VPC2 to VPC3 NAT rules"
  type        = string
}

variable "vpc3_to_vpc2_source_cidr" {
  description = "Source CIDR block for VPC3 to VPC2 NAT rules"
  type        = string
}

variable "vpc3_to_vpc2_translated_cidr" {
  description = "Translated CIDR block for VPC3 to VPC2 NAT rules"
  type        = string
}

variable "tgw_route_table_id" {
  description = "ID of the Transit Gateway route table"
  type        = string
  default     = ""
}

# modules/nat_rules/outputs.tf

output "vpc2_to_vpc3_nat_id" {
  description = "ID of the VPC2 to VPC3 NAT connection"
  value       = aws_ec2_transit_gateway_connect.vpc2_to_vpc3.id
}

output "vpc3_to_vpc2_nat_id" {
  description = "ID of the VPC3 to VPC2 NAT connection"
  value       = aws_ec2_transit_gateway_connect.vpc3_to_vpc2.id
}

output "global_network_id" {
  description = "ID of the Network Manager global network"
  value       = aws_networkmanager_global_network.this.id
}