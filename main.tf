locals {
  len_public_subnets  = max(length(var.public_subnets))
  len_private_subnets = max(length(var.private_subnets))
}

########## AWS VPC ##########

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    {
      "Name" = "${var.env}-${var.region_name}-vpc"
    },
    var.tags,
  )
}

########## AWS Internet Iateway ##########

resource "aws_internet_gateway" "igw" {
  count = var.create_internet_gateway ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = "${var.env}-${var.region_name}-vpc-igw"
    },
    var.tags,
  )
}

########## AWS Public Subnets ##########

resource "aws_subnet" "public" {
  count = var.create_public_subnets ? length(var.public_subnets) : 0

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format("%s-%s-vpc-public-subnet-%s", var.env, var.region_name, count.index + 1)
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  count = var.create_public_route_table ? 1 : 0

  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = "${var.env}-${var.region_name}-vpc-pblc-rtbl"
    },
    var.tags,
  )
}

resource "aws_route_table_association" "public" {
  count = var.create_public_subnets ? local.len_public_subnets : 0

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route" "public_route" {
  count = var.create_public_subnets ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id

  depends_on = [
    aws_route_table.public,
    aws_internet_gateway.igw
  ]
}

########## AWS Private Subnets ##########

resource "aws_subnet" "private" {
  count             = var.create_private_subnets ? length(var.private_subnets) : 0
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format("%s-%s-vpc-private-subnet-%s", var.env, var.region_name, count.index + 1)
    },
    var.tags,
  )
}

resource "aws_route_table" "private" {
  count  = var.create_private_route_table ? 1 : 0
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = "${var.env}-${var.region_name}-vpc-prvt-rtbl"
    },
    var.tags,
  )
}

resource "aws_route_table_association" "private" {
  count = var.create_private_subnets ? local.len_private_subnets : 0

  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private[0].id
}

resource "aws_route" "private_route" {
  count                  = var.create_private_subnets ? 1 : 0
  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id

  depends_on = [
    aws_route_table.private,
    aws_nat_gateway.nat_gateway
  ]
}

########## AWS EIP ##########

resource "aws_eip" "eip" {
  count  = var.create_eip ? 1 : 0
  domain = "vpc"


  tags = merge(
    {
      "Name" = "nat-${var.env}-${var.region_name}-vpc-eip"
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.igw]
}

########## AWS Nat Gateway ##########

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.create_nat ? 1 : 0
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = aws_subnet.public[count.index].id


  tags = merge(
    {
      "Name" = "${var.env}-${var.region_name}-vpc-nat"
    },
    var.tags,
  )

  depends_on = [aws_internet_gateway.igw]
}