# -------------------------------------
# VPC
# -------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}-vpc"
  }
}

# -------------------------------------
# Internet Gateway
# -------------------------------------
resource "aws_internet_gateway" "internetgateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-IG"
  }
}

# -------------------------------------
# Subnets (Public)
# -------------------------------------
resource "aws_subnet" "publicsubnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-subnet-${count.index + 1}"
  }
}

# -------------------------------------
# Route Table (Public)
# -------------------------------------
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internetgateway.id
  }

  tags = {
     Name = "${var.name}-public-route-table"
  }
}

# -------------------------------------
# Route Table Associations
# -------------------------------------
resource "aws_route_table_association" "public_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.publicsubnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}


# -------------------------------------
# Network ACL
# -------------------------------------
resource "aws_network_acl" "public_acl" {
  vpc_id = aws_vpc.vpc.id

   subnet_ids = aws_subnet.publicsubnets[*].id

  # Allow all inbound traffic
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Allow all outbound traffic
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "${var.name}-Network-ACL"
  }
}


