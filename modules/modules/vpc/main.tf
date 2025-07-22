resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "this" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-igw"
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.name}-public-${each.key}"
  }
}

resource "aws_route_table" "public" {
  count  = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this[0].id
  }

  tags = {
    Name = "${var.name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[0].id
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = {
    Name = "${var.name}-private-${each.key}"
  }
}

resource "aws_eip" "nat" {
  for_each = var.enable_nat_gateway ? var.private_subnets : {}

  vpc = true

  tags = {
    Name = "${var.name}-eip-${each.key}"
  }
}

resource "aws_nat_gateway" "this" {
  for_each = var.enable_nat_gateway ? var.private_subnets : {}

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "${var.name}-nat-${each.key}"
  }

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "private" {
  for_each = var.private_subnets
  vpc_id   = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.enable_nat_gateway ? aws_nat_gateway.this[each.key].id : null
  }

  tags = {
    Name = "${var.name}-private-rt-${each.key}"
  }
}

resource "aws_route_table_association" "private" {
  for_each       = var.private_subnets
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}
