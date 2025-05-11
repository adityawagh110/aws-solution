
provider "aws" {
  region = "us-east-1"
}

# Transit Gateway Configuration
module "transit_gateway" {
  source = "./modules/transit_gateway"
  
  # VPC CIDR blocks for route table configuration
  vpc2_cidr     = "172.168.16.0/20"
  vpc3_cidr     = "172.168.16.0/20"
  datacenter_cidr = "172.168.32.0/20"
  
  # Transit Gateway tags
  name = "vgsc-transit-gateway"
  environment = "production"
}

# Direct Connect Configuration
module "direct_connect" {
  source = "./modules/direct_connect"
  
  # Direct Connect parameters
  connection_name = "vgsc-dc-ireland"
  bandwidth = "10Gbps"
  location = "AWS Direct Connect location near Ireland"
  transit_gateway_id = module.transit_gateway.tgw_id
  
  # BGP parameters
  bgp_asn = 65000
  amazon_asn = 64512
}

# VPN Backup Configuration
module "vpn_backup" {
  source = "./modules/vpn"
  
  # VPN parameters
  transit_gateway_id = module.transit_gateway.tgw_id
  customer_gateway_ip = "203.0.113.1" # Example IP of datacenter edge router
  customer_gateway_asn = 65000
  name = "vgsc-vpn-backup"
}

# Developer VPC2 Configuration
module "vpc2" {
  source = "./modules/vpc"
  
  name = "developer-vpc2"
  cidr_block = "172.168.16.0/20"
  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
  
  # Subnets configuration
  private_subnets = ["172.168.16.0/24", "172.168.17.0/24", "172.168.18.0/24"]
  public_subnets = ["172.168.19.0/24", "172.168.20.0/24", "172.168.21.0/24"]
  
  # Transit Gateway attachment
  transit_gateway_id = module.transit_gateway.tgw_id
}

# Services VPC3 Configuration
module "vpc3" {
  source = "./modules/vpc"
  
  name = "services-vpc3"
  cidr_block = "172.168.16.0/20"
  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
  
  # Subnets configuration
  private_subnets = ["172.168.16.0/24", "172.168.17.0/24", "172.168.18.0/24"]
  public_subnets = ["172.168.19.0/24", "172.168.20.0/24", "172.168.21.0/24"]
  
  # Transit Gateway attachment  
  transit_gateway_id = module.transit_gateway.tgw_id
}

# NAT Gateways for VPC2
resource "aws_nat_gateway" "vpc2_nat" {
  count = 3
  allocation_id = aws_eip.vpc2_nat_eip[count.index].id
  subnet_id = module.vpc2.public_subnet_ids[count.index]
  
  tags = {
    Name = "vpc2-nat-gateway-${count.index}"
  }
}

resource "aws_eip" "vpc2_nat_eip" {
  count = 3
  vpc = true
}

# NAT Gateways for VPC3
resource "aws_nat_gateway" "vpc3_nat" {
  count = 3
  allocation_id = aws_eip.vpc3_nat_eip[count.index].id
  subnet_id = module.vpc3.public_subnet_ids[count.index]
  
  tags = {
    Name = "vpc3-nat-gateway-${count.index}"
  }
}

resource "aws_eip" "vpc3_nat_eip" {
  count = 3
  vpc = true
}

# Transit Gateway Route Tables configuration
module "tgw_route_tables" {
  source = "./modules/tgw_route_tables"
  
  # Transit Gateway ID
  transit_gateway_id = module.transit_gateway.tgw_id
  
  # Attachment IDs
  vpc2_attachment_id = module.vpc2.tgw_attachment_id
  vpc3_attachment_id = module.vpc3.tgw_attachment_id
  direct_connect_attachment_id = module.direct_connect.dx_gateway_attachment_id
  vpn_attachment_id = module.vpn_backup.vpn_attachment_id
  
  # CIDR blocks
  vpc2_cidr = "172.168.16.0/20"
  vpc3_cidr = "172.168.16.0/20"
  datacenter_cidr = "172.168.32.0/20"
}

# Network Address Translation Rules configuration for IP overlap handling
module "nat_rules" {
  source = "./modules/nat_rules"
  
  # Transit Gateway ID
  transit_gateway_id = module.transit_gateway.tgw_id
  
  # Attachment IDs
  vpc2_attachment_id = module.vpc2.tgw_attachment_id
  vpc3_attachment_id = module.vpc3.tgw_attachment_id
  
  # NAT rules for VPC2 to VPC3 communication
  vpc2_to_vpc3_source_cidr = "172.168.16.0/20"
  vpc2_to_vpc3_translated_cidr = "100.64.0.0/20"  # RFC 6598 address space
  
  # NAT rules for VPC3 to VPC2 communication
  vpc3_to_vpc2_source_cidr = "172.168.16.0/20"
  vpc3_to_vpc2_translated_cidr = "100.64.16.0/20"  # RFC 6598 address space
}

# Output values
output "transit_gateway_id" {
  value = module.transit_gateway.tgw_id
  description = "ID of the created Transit Gateway"
}

output "direct_connect_id" {
  value = module.direct_connect.dx_connection_id
  description = "ID of the Direct Connect connection"
}

output "vpn_connection_id" {
  value = module.vpn_backup.vpn_connection_id
  description = "ID of the Site-to-Site VPN connection"
}