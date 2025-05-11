
# Get current AWS account ID
data "aws_caller_identity" "current" {}

# Create Transit Gateway Network Manager
resource "aws_networkmanager_global_network" "this" {
  description = "Network Manager for Transit Gateway NAT"
  
  tags = {
    Name = "vgsc-global-network"
  }
}

# Register Transit Gateway with Network Manager
resource "aws_networkmanager_transit_gateway_registration" "this" {
  global_network_id   = aws_networkmanager_global_network.this.id
  transit_gateway_arn = "arn:aws:ec2:us-east-1:${data.aws_caller_identity.current.account_id}:transit-gateway/${var.transit_gateway_id}"
  
  depends_on = [aws_networkmanager_global_network.this]
}

# Create NAT configuration for VPC2 to VPC3
resource "aws_ec2_transit_gateway_connect" "vpc2_to_vpc3" {
  transport_transit_gateway_attachment_id = var.vpc2_attachment_id
  transit_gateway_id                      = var.transit_gateway_id
  
  tags = {
    Name = "vpc2-to-vpc3-nat"
  }
}

# Create NAT configuration for VPC3 to VPC2
resource "aws_ec2_transit_gateway_connect" "vpc3_to_vpc2" {
  transport_transit_gateway_attachment_id = var.vpc3_attachment_id
  transit_gateway_id                      = var.transit_gateway_id
  
  tags = {
    Name = "vpc3-to-vpc2-nat"
  }
}

# Create NAT rules for VPC2 to VPC3 (twice-NAT)
resource "aws_ec2_transit_gateway_connect_peer" "vpc2_to_vpc3" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_connect.vpc2_to_vpc3.id
  peer_address                   = "169.254.100.1"
  bgp_asn                        = 64512
  inside_cidr_blocks             = ["169.254.101.0/29"]
  
  bgp_inside_cidr_blocks = [
    "169.254.101.8/29",
  ]
  
  tags = {
    Name = "vpc2-to-vpc3-nat-peer"
  }
}

# Create NAT rules for VPC3 to VPC2 (twice-NAT)
resource "aws_ec2_transit_gateway_connect_peer" "vpc3_to_vpc2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_connect.vpc3_to_vpc2.id
  peer_address                   = "169.254.100.2"
  bgp_asn                        = 64512
  inside_cidr_blocks             = ["169.254.102.0/29"]
  
  bgp_inside_cidr_blocks = [
    "169.254.102.8/29",
  ]
  
  tags = {
    Name = "vpc3-to-vpc2-nat-peer"
  }
}

# Configure route tables in the Transit Gateway to apply NAT translations
resource "aws_ec2_transit_gateway_route" "vpc2_to_vpc3" {
  destination_cidr_block         = var.vpc3_to_vpc2_translated_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_connect_peer.vpc2_to_vpc3.id
  transit_gateway_route_table_id = var.tgw_route_table_id
}

resource "aws_ec2_transit_gateway_route" "vpc3_to_vpc2" {
  destination_cidr_block         = var.vpc2_to_vpc3_translated_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_connect_peer.vpc3_to_vpc2.id
  transit_gateway_route_table_id = var.tgw_route_table_id
}

