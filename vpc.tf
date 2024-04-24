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
resource "aws_subnet" module.label_vpc.tags {
    vpc_id = aws_vpc.main.id
    cidr_block = var.vpc_cidr
    map_public_ip_on_launch = "true"
    availability_zone = "us-west-1a"
    tags = {
        Name = module.label_vpc.tags
    }
}

resource "aws_subnet" module.label_vpc.tags {
    vpc_id = aws_vpc.main.id
    cidr_block = var.vpc_cidr
    map_public_ip_on_launch = "false"
    availability_zone = "us-west-1a"
    tags = {
        Name = module.label_vpc.tags
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
        Name = module.label_vpc.tags
    }
}

# For Route associations public
resource "aws_route_table_association" "main-public-1-a" {
    subnet_id = aws_subnet.main-public-1.id
    route_table_id = aws_route_table.main-public.id
}

