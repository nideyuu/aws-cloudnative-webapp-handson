# ==============================
# VPC
# ==============================

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# ==============================
# Public Subnets
# ==============================

resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1a_cidr
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1c_cidr
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-1c"
  }
}

# ==============================
# Private App Subnets
# ==============================

resource "aws_subnet" "private_app_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_1a_cidr
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.project_name}-private-app-subnet-1a"
  }
}

resource "aws_subnet" "private_app_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_1c_cidr
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.project_name}-private-app-subnet-1c"
  }
}

# ==============================
# Private DB Subnets
# ==============================

resource "aws_subnet" "private_db_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_1a_cidr
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.project_name}-private-db-subnet-1a"
  }
}

resource "aws_subnet" "private_db_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_1c_cidr
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "${var.project_name}-private-db-subnet-1c"
  }
}

# ==============================
# Internet Gateway
# ==============================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# ==============================
# Elastic IP for NAT Gateway
# ==============================

resource "aws_eip" "nat_1a" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-nat-eip-1a"
  }
}

# ==============================
# NAT Gateway
# ==============================

resource "aws_nat_gateway" "main_1a" {
  allocation_id = aws_eip.nat_1a.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name = "${var.project_name}-nat-1a"
  }

  depends_on = [
    aws_internet_gateway.main
  ]
}

# ==============================
# Public Route Table
# ==============================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

# ==============================
# Private App Route Table
# ==============================

resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-private-app-rt"
  }
}

resource "aws_route" "private_app_default" {
  route_table_id         = aws_route_table.private_app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main_1a.id
}

resource "aws_route_table_association" "private_app_1a" {
  subnet_id      = aws_subnet.private_app_1a.id
  route_table_id = aws_route_table.private_app.id
}

resource "aws_route_table_association" "private_app_1c" {
  subnet_id      = aws_subnet.private_app_1c.id
  route_table_id = aws_route_table.private_app.id
}

# ==============================
# Private DB Route Table
# ==============================

resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-private-db-rt"
  }
}

resource "aws_route_table_association" "private_db_1a" {
  subnet_id      = aws_subnet.private_db_1a.id
  route_table_id = aws_route_table.private_db.id
}

resource "aws_route_table_association" "private_db_1c" {
  subnet_id      = aws_subnet.private_db_1c.id
  route_table_id = aws_route_table.private_db.id
}
