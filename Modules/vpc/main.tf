# modules/vpc/main.tf

# Create VPC
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  
  tags = {
    Name = var.name
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.name}-public-${count.index + 1}"
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]
  
  tags = {
    Name = "${var.name}-private-${count.index + 1}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  
  tags = {
    Name = "${var.name}-igw"
  }
}

# Create public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  
  tags = {
    Name = "${var.name}-public-rt"
  }
}

# Create default route to Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Create private route tables
resource "aws_route_table" "private" {
  count = length(var.private_subnets)
  
  vpc_id = aws_vpc.this.id
  
  tags = {
    Name = "${var.name}-private-rt-${count.index + 1}"
  }
}

# Associate private subnets with private route tables
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)
  
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# Create Transit Gateway Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  subnet_ids         = aws_subnet.private[*].id
  transit_gateway_id = var.transit_gateway_id
  vpc_id             = aws_vpc.this.id
  
  # Configure appliance mode for NAT to work correctly
  appliance_mode_support = "enable"
  
  # Enable DNS support
  dns_support = "enable"
  
  tags = {
    Name = "${var.name}-tgw-attachment"
  }
}

# Create routes to Transit Gateway for inter-VPC and data center traffic
resource "aws_route" "to_transit_gateway" {
  count = length(var.private_subnets)
  
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"  # We're using the Transit Gateway as the default route
  transit_gateway_id     = var.transit_gateway_id
  
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}

