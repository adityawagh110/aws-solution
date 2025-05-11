# modules/vpn/main.tf

# Create Customer Gateway
resource "aws_customer_gateway" "this" {
  bgp_asn    = var.customer_gateway_asn
  ip_address = var.customer_gateway_ip
  type       = "ipsec.1"
  
  tags = {
    Name = "${var.name}-customer-gateway"
  }
}

# Create VPN Connection
resource "aws_vpn_connection" "this" {
  customer_gateway_id     = aws_customer_gateway.this.id
  transit_gateway_id      = var.transit_gateway_id
  type                    = aws_customer_gateway.this.type
  tunnel_inside_ip_version = "ipv4"
  
  # Enable acceleration for better performance
  enable_acceleration     = true
  
  # Enable BGP routing
  tunnel1_dpd_timeout_action = "restart"
  tunnel1_dpd_timeout_seconds = 30
  tunnel1_phase1_dh_group_numbers = [14]
  tunnel1_phase1_encryption_algorithms = ["AES256"]
  tunnel1_phase1_integrity_algorithms = ["SHA2-256"]
  tunnel1_phase2_dh_group_numbers = [14]
  tunnel1_phase2_encryption_algorithms = ["AES256"]
  tunnel1_phase2_integrity_algorithms = ["SHA2-256"]
  
  tunnel2_dpd_timeout_action = "restart"
  tunnel2_dpd_timeout_seconds = 30
  tunnel2_phase1_dh_group_numbers = [14]
  tunnel2_phase1_encryption_algorithms = ["AES256"]
  tunnel2_phase1_integrity_algorithms = ["SHA2-256"]
  tunnel2_phase2_dh_group_numbers = [14]
  tunnel2_phase2_encryption_algorithms = ["AES256"]
  tunnel2_phase2_integrity_algorithms = ["SHA2-256"]
  
  tags = {
    Name = "${var.name}-vpn-connection"
  }
}

