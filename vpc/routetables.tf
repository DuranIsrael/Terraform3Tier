# ---.vpc/routetables.tf ---

resource "aws_route_table_association" "public_assoc" {
  count = var.public_sn_count
  subnet_id = aws_subnet.public_subnet.*.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.wk22_vpc.id

  tags = {
    Name = "public_rt"
  }

}
resource "aws_route" "default_route" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.wk22_vpc.id

  tags = {
    Name = "private_rt"
  }
}