resource "aws_vpc" "test_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "test_public_sub" {
  vpc_id                  = aws_vpc.test_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public"
  }

}

resource "aws_internet_gateway" "test_IG" {
  vpc_id = aws_vpc.test_vpc.id
  tags = {
    Name = "dev-IGW"
  }
}

resource "aws_route_table" "test_rt" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "Dev_rt"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.test_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.test_IG.id
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.test_public_sub.id
  route_table_id = aws_route_table.test_rt.id

}

resource "aws_security_group" "dev_sg" {
  name        = "dev_sg"
  description = "dev_security_group"
  vpc_id      = aws_vpc.test_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] // blockS expect a list
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "test_auth" {
  key_name   = "testkey"
  public_key = file("~/.ssh/testkey.pub")
}

resource "aws_instance" "public_server_dev" {
  instance_type          = "t4g.small"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.test_auth.id
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  subnet_id              = aws_subnet.test_public_sub.id
  user_data              = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev_server"
  }
  provisioner "local-exec" {
    command = templatefile("${var.host_os}-ssh-config.tpl", {
        hostname = self.public_ip,
        user = "ubuntu",
        identityfile = "~/.ssh/testkey"
    })
    interpreter = var.host_os == "mac" ? ["bash", "-c"] : ["Powershell" , "-Command"]
    }
}