# modules/tgw_route_tables/main.tf

# Create route associations for VPC2 attachment
resource "aws_ec2_transit_gateway_route_table_association" "vpc2" {
  transit_gateway_attachment_id  = var.vpc2_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc2.id
}

# Create route associations for VPC3 attachment
resource "aws_ec2_transit_gateway_route_table_association" "vpc3" {
  transit_gateway_attachment_id  = var.vpc3_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc3.id
}

# Create route associations for Direct Connect attachment
resource "aws_ec2_transit_gateway_route_table_association" "direct_connect" {
  transit_gateway_attachment_id  = var.direct_connect_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.direct_connect.id
}

# Create route associations for VPN attachment
resource "aws_ec2_transit_gateway_route_table_association" "vpn" {
  transit_gateway_attachment_id  = var.vpn_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpn.id
}

# Create Transit Gateway route table for VPC2
resource "aws_ec2_transit_gateway_route_table" "vpc2" {
  transit_gateway_id = var.transit_gateway_id
  
  tags = {
    Name = "vpc2-route-table"
  }
}

# Create Transit Gateway route table for VPC3
resource "aws_ec2_transit_gateway_route_table" "vpc3" {
  transit_gateway_id = var.transit_gateway_id
  
  tags = {
    Name = "vpc3-route-table"
  }
}

# Create Transit Gateway route table for Direct Connect
resource "aws_ec2_transit_gateway_route_table" "direct_connect" {
  transit_gateway_id = var.transit_gateway_id
  
  tags = {
    Name = "direct-connect-route-table"
  }
}

# Create Transit Gateway route table for VPN
resource "aws_ec2_transit_gateway_route_table" "vpn" {
  transit_gateway_id = var.transit_gateway_id
  
  tags = {
    Name = "vpn-route-table"
  }
}

# Routes from VPC2 to Data Center via Direct Connect
resource "aws_ec2_transit_gateway_route" "vpc2_to_dc" {
  destination_cidr_block         = var.datacenter_cidr
  transit_gateway_attachment_id  = var.direct_connect_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc2.id
}

# Routes from VPC2 to VPC3 via NAT
resource "aws_ec2_transit_gateway_route" "vpc2_to_vpc3" {
  destination_cidr_block         = var.vpc3_cidr
  transit_gateway_attachment_id  = var.vpc3_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc2.id
  
  # Blackhole this route initially to prevent routing loops while NAT is being set up
  blackhole = true
}

# Routes from VPC3 to Data Center via Direct Connect
resource "aws_ec2_transit_gateway_route" "vpc3_to_dc" {
  destination_cidr_block         = var.datacenter_cidr
  transit_gateway_attachment_id  = var.direct_connect_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc3.id
}

# Routes from VPC3 to VPC2 via NAT
resource "aws_ec2_transit_gateway_route" "vpc3_to_vpc2" {
  destination_cidr_block         = var.vpc2_cidr
  transit_gateway_attachment_id  = var.vpc2_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc3.id
  
  # Blackhole this route initially to prevent routing loops while NAT is being set up
  blackhole = true
}

# Routes from Data Center to VPC2
resource "aws_ec2_transit_gateway_route" "dc_to_vpc2" {
  destination_cidr_block         = var.vpc2_cidr
  transit_gateway_attachment_id  = var.vpc2_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.direct_connect.id
}

# Routes from Data Center to VPC3
resource "aws_ec2_transit_gateway_route" "dc_to_vpc3" {
  destination_cidr_block         = var.vpc3_cidr
  transit_gateway_attachment_id  = var.vpc3_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.direct_connect.id
}

# Routes from VPN to VPC2
resource "aws_ec2_transit_gateway_route" "vpn_to_vpc2" {
  destination_cidr_block         = var.vpc2_cidr
  transit_gateway_attachment_id  = var.vpc2_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpn.id
}

# Routes from VPN to VPC3
resource "aws_ec2_transit_gateway_route" "vpn_to_vpc3" {
  destination_cidr_block         = var.vpc3_cidr
  transit_gateway_attachment_id  = var.vpc3_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpn.id
}

# Propagate routes from VPC2 to Data Center
resource "aws_ec2_transit_gateway_route_table_propagation" "vpc2_to_dc" {
  transit_gateway_attachment_id  = var.vpc2_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.direct_connect.id
}

# Propagate routes from VPC3 to Data Center
resource "aws_ec2_transit_gateway_route_table_propagation" "vpc3_to_dc" {
  transit_gateway_attachment_id  = var.vpc3_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.direct_connect.id
}

# Propagate routes from Data Center to VPC2
resource "aws_ec2_transit_gateway_route_table_propagation" "dc_to_vpc2" {
  transit_gateway_attachment_id  = var.direct_connect_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc2.id
}

# Propagate routes from Data Center to VPC3
resource "aws_ec2_transit_gateway_route_table_propagation" "dc_to_vpc3" {
  transit_gateway_attachment_id  = var.direct_connect_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc3.id
}



