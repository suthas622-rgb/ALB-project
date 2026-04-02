resource "aws_vpc" "projectvpc" {
  cidr_block = "192.168.0.0/24"
}

resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.projectvpc.id
  cidr_block = "192.168.0.0/26 "
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.projectvpc.id
  cidr_block = "192.168.0.128/26"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.projectvpc.id

}

resource "aws_route_table" "publicrtb" {
  vpc_id = aws_vpc.projectvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "privatertb" {
  vpc_id = aws_vpc.projectvpc.id
  route {
    cidr_block = "0.0.0.0/0"
  }
}

resource "aws_route_table_association" "publicAssos" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.publicrtb.id
}

resource "aws_route_table_association" "privateassos" {
  route_table_id = aws_route_table.privatertb.id
  subnet_id = aws_subnet.private_subnets.id
}

resource "aws_lb" "myalb" {
  name = "testing-load"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.security_group_id.id]
  subnets = var.subnet_id.id
}


resource "aws_lb_target_group" "http" {
  name = "httptg"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 30
    timeout = 5
    unhealthy_threshold = 2

  }
}

