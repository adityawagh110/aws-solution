variable "connection_name" {
  description = "Name for the Direct Connect connection"
  type        = string
}

variable "bandwidth" {
  description = "Bandwidth for the Direct Connect connection"
  type        = string
  default     = "10Gbps"
}

variable "location" {
  description = "AWS Direct Connect location"
  type        = string
}

variable "provider_name" {
  description = "The name of the Direct Connect provider"
  type        = string
  default     = "Example Provider"
}

variable "vlan_id" {
  description = "VLAN ID for the Direct Connect virtual interface"
  type        = number
  default     = 4094
}

variable "bgp_asn" {
  description = "BGP ASN for customer side of the BGP session"
  type        = number
}

variable "amazon_asn" {
  description = "BGP ASN for the Amazon side of the BGP session"
  type        = number
}

variable "transit_gateway_id" {
  description = "ID of the Transit Gateway to associate with"
  type        = string
}

variable "amazon_address" {
  description = "IP address assigned to the Amazon interface"
  type        = string
  default     = "169.254.0.1/30"
}

variable "customer_address" {
  description = "IP address assigned to the customer interface"
  type        = string
  default     = "169.254.0.2/30"
}



