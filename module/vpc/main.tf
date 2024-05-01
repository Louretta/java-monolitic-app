locals {
  name = "petclinic"
}


resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name}-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.vpc.id
  count             = 3
  cidr_block        = element(var.public-subnet, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${local.name}-public-subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.vpc.id
  count             = 3
  cidr_block        = element(var.private-subnet, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${local.name}-private-subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${local.name}-gw"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet[0].id

  tags = {
    Name = "${local.name}-nat-gw"
  }
}


resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${local.name}-public-rt"
  }
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "${local.name}-private-rt"
  }
}

resource "aws_route_table_association" "public-association" {
  count          = 3
  subnet_id      = aws_subnet.public-subnet[count.index].id
 route_table_id  = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "private-association" {
  count          = 3
  subnet_id      = aws_subnet.private-subnet[count.index].id
 route_table_id  = aws_route_table.private-rt.id
}

resource "aws_eip" "eip" {
  domain   = "vpc"
  tags = {
    Name = "${local.name}-eip"
  }
}

