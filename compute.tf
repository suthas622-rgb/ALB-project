resource "aws_instance" "webserver" {
  ami = "ami-01b14b7ad41e17ba4"
  associate_public_ip_address = true
  security_groups = [ aws_security_group.sgserver.id ]
  instance_type = t3.micro
  subnet_id = aws_subnet.private_subnets.id

  root_block_device {
    delete_on_termination = true
    volume_size = 5
    volume_type = "gp2"
  }
}

resource "aws_security_group" "sgserver" {
  name = "security group for server"
  vpc_id = aws_vpc.projectvpc.id
}

resource "aws_security_group_ingress_rule" "allowtraffic" {
  security_group_id = aws_security_group.sgserver.id
  cidr_blocks = "0.0.0.0/0"
  from_port = 80
  to_port = 80
  ip_protocol = "tcp"
}

