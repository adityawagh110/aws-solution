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

variable "direct_connect_attachment_id" {
  description = "ID of the Direct Connect attachment to Transit Gateway"
  type        = string
}

variable "vpn_attachment_id" {
  description = "ID of the VPN attachment to Transit Gateway"
  type        = string
}

variable "vpc2_cidr" {
  description = "CIDR block for VPC2"
  type        = string
}

variable "vpc3_cidr" {
  description = "CIDR block for VPC3"
  type        = string
}

variable "datacenter_cidr" {
  description = "CIDR block for Data Center"
  type        = string
}

