module "label_vpc" {
  source     = "cloudposse/label/null"
  version    = "0.25.0"
  context    = module.base_label.context
  name       = "vpc"
  attributes = ["main"]
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = module.label_vpc.tags
}

# =========================
# Create your subnets here
# =========================
# For Subnets
resource "aws_subnet" "main-public-1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "192.170.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-1a"
    tags = {
        Name = "main-public-1"
    }
}

resource "aws_subnet" "main-private-1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "192.170.4.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-1a"
    tags = {
        Name = "main-private-1"
    }
}

# For Internet Gateway
resource "aws_internet_gateway" "main-gw" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "main"
    }
} 

# For Route Tables
resource "aws_route_table" "main-public" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main-gw.id
    }
    tags = {
        Name = "main-public-1"
    }
}

# For Route associations public
resource "aws_route_table_association" "main-public-1-a" {
    subnet_id = aws_subnet.main-public-1.id
    route_table_id = aws_route_table.main-public.id
}

