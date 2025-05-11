# modules/vpn/variables.tf

variable "name" {
  description = "Name prefix for VPN resources"
  type        = string
  default     = "backup-vpn"
}

variable "transit_gateway_id" {
  description = "ID of the Transit Gateway to attach the VPN to"
  type        = string
}

variable "customer_gateway_ip" {
  description = "Public IP address of the customer gateway"
  type        = string
}

variable "customer_gateway_asn" {
  description = "BGP ASN of the customer gateway"
  type        = number
  default     = 65000
}

