# modules/direct_connect/main.tf

# Create Direct Connect Gateway
resource "aws_dx_gateway" "this" {
  name            = "${var.connection_name}-gateway"
  amazon_side_asn = var.amazon_asn
}

# Create Direct Connect Connection
# Note: In practice, this usually requires coordination with AWS support
# and the Direct Connect provider at the specific location
resource "aws_dx_connection" "this" {
  name            = var.connection_name
  bandwidth       = var.bandwidth
  location        = var.location
  provider_name   = var.provider_name
  
  tags = {
    Name        = var.connection_name
    Environment = "production"
  }
}

# Create Direct Connect Virtual Interface
resource "aws_dx_private_virtual_interface" "this" {
  connection_id    = aws_dx_connection.this.id
  name             = "${var.connection_name}-vif"
  vlan             = var.vlan_id
  address_family   = "ipv4"
  bgp_asn          = var.bgp_asn
  dx_gateway_id    = aws_dx_gateway.this.id
  amazon_address   = var.amazon_address
  customer_address = var.customer_address
  
  tags = {
    Name        = "${var.connection_name}-vif"
    Environment = "production"
  }
}

# Associate Direct Connect Gateway with Transit Gateway
resource "aws_dx_gateway_association" "this" {
  dx_gateway_id        = aws_dx_gateway.this.id
  associated_gateway_id = var.transit_gateway_id
  
  allowed_prefixes = [
    "172.168.16.0/20", # VPC2 and VPC3 CIDR (they overlap)
    "172.168.32.0/20", # Data Center CIDR
    "100.64.0.0/19"    # NAT translation CIDR range
  ]
}



