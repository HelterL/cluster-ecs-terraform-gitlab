resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    "Name" : "${var.name}-VPC-${var.environment}"
    "Environment" : var.environment
  }
}

data "aws_availability_zones" "available" {
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags = {
    "Name" : "${var.name}-IGW-${var.environment}"
    "Environment" : var.environment
  }
}

resource "aws_eip" "eip_nat" {
  domain = "vpc"
  tags = {
    "Name" : "${var.name}-EIP-NAT-${var.environment}"
    "Environment" : var.environment
  }
}

resource "aws_nat_gateway" "main" {
  allocation_id = "${aws_eip.eip_nat.id}"
  subnet_id = "${element(aws_subnet.private.*.id, 0)}"
  depends_on = [ aws_internet_gateway.main ]
  
  tags = {
    "Name" : "${var.name}-NAT-${var.environment}"
    "Environment" : var.environment
  }
}


resource "aws_subnet" "public" {
  count = var.public_subnets
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block = "10.0.${count.index+1}.0/24"
  map_public_ip_on_launch = true

tags = {
    "Name" : "${var.name}-SUB_PUBL-${var.environment}"
    "Environment" : var.environment
  }
}

resource "aws_subnet" "private" {
  count = var.private_subnets
  vpc_id = "${aws_vpc.main.id}"
  availability_zone =  data.aws_availability_zones.available.names[count.index]
  cidr_block = "10.0.${count.index+3}.0/24"
  
  tags = {
    "Name" : "${var.name}-SUB_PRIV-${var.environment}"
    "Environment" : var.environment
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    "Name" : "${var.name}-RT-PRIV-${var.environment}"
    "Environment" : var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    "Name" : "${var.name}-RT_PUBL-${var.environment}"
    "Environment" : var.environment
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}
resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.main.id}"
}
/* Route table associations */
resource "aws_route_table_association" "public" {
  count          =  var.public_subnets
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "private" {
  count          =  var.private_subnets
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnets_ids" {
  value = aws_subnet.private.*.id
}