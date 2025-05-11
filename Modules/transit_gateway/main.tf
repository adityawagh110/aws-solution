# Create Transit Gateway
resource "aws_ec2_transit_gateway" "this" {
  description                     = "Transit Gateway for Very Good Software Corporation"
  amazon_side_asn                 = 64512
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  
  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

# Create Transit Gateway route tables - one for each attachment type
resource "aws_ec2_transit_gateway_route_table" "vpc" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  
  tags = {
    Name = "${var.name}-vpc-rt"
  }
}

resource "aws_ec2_transit_gateway_route_table" "direct_connect" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  
  tags = {
    Name = "${var.name}-dx-rt"
  }
}

resource "aws_ec2_transit_gateway_route_table" "vpn" {
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  
  tags = {
    Name = "${var.name}-vpn-rt"
  }
}

# Transit Gateway prefix list for IP overlap mitigation
resource "aws_ec2_managed_prefix_list" "vpc_cidrs" {
  name           = "VPC-CIDR-Blocks"
  address_family = "IPv4"
  max_entries    = 100  # Allow for future expansion
  
  entry {
    cidr        = var.vpc2_cidr
    description = "Developer VPC2 CIDR Block"
  }
  
  entry {
    cidr        = var.vpc3_cidr
    description = "Services VPC3 CIDR Block"
  }
  
  entry {
    cidr        = var.datacenter_cidr
    description = "Data Center Ireland CIDR Block"
  }
  
  tags = {
    Name = "${var.name}-vpc-cidrs"
  }
}