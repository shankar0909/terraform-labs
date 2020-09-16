provider "aws" {
  region=var.region
}

resource "aws_vpc" "tf_vpc" {
  cidr_block=var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-VPC"
  }
}

resource "aws_subnet" "public_subnet_1" {
  cidr_block=var.public_subnet_cidr_1
  vpc_id=aws_vpc.tf_vpc.id
  availability_zone="us-east-1a"

  tags = {
    Name = "Public-Subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  cidr_block=var.public_subnet_cidr_2
  vpc_id=aws_vpc.tf_vpc.id
  availability_zone="us-east-1b"

  tags = {
    Name = "Public-Subnet-2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  cidr_block=var.public_subnet_cidr_3
  vpc_id=aws_vpc.tf_vpc.id
  availability_zone="us-east-1c"

  tags = {
    Name = "Public-Subnet-3"
  }
}

resource "aws_subnet" "private_subnet_1" {
  cidr_block=var.private_subnet_cidr_1
  vpc_id=aws_vpc.tf_vpc.id
  availability_zone="us-east-1a"
  tags = {
    Name = "Private-Subnet-1"
  }

}

resource "aws_subnet" "private_subnet_2" {
  cidr_block=var.private_subnet_cidr_2
  vpc_id=aws_vpc.tf_vpc.id
  availability_zone="us-east-1b"
  tags = {
    Name = "Private-Subnet-2"
  }

}

resource "aws_subnet" "private_subnet_3" {
  cidr_block=var.private_subnet_cidr_3
  vpc_id=aws_vpc.tf_vpc.id
  availability_zone="us-east-1c"
  tags = {
    Name = "Private-Subnet-3"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id=aws_vpc.tf_vpc.id
  tags = {
    Name="Public-Route-Table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id=aws_vpc.tf_vpc.id
  tags = {
    Name="Private-Route-Table"
  }
}

resource "aws_route_table_association" "public_subnet_association_1" {
    route_table_id=aws_route_table.public_route_table.id
    subnet_id=aws_subnet.public_subnet_1.id
}

resource "aws_route_table_association" "public_subnet_association_2" {
    route_table_id=aws_route_table.public_route_table.id
    subnet_id=aws_subnet.public_subnet_2.id
}

resource "aws_route_table_association" "public_subnet_association_3" {
    route_table_id=aws_route_table.public_route_table.id
    subnet_id=aws_subnet.public_subnet_3.id
}

resource "aws_route_table_association" "private_subnet_association_1" {
    route_table_id=aws_route_table.private_route_table.id
    subnet_id=aws_subnet.private_subnet_1.id
}

resource "aws_route_table_association" "private_subnet_association_2" {
    route_table_id=aws_route_table.private_route_table.id
    subnet_id=aws_subnet.private_subnet_2.id
}

resource "aws_route_table_association" "private_subnet_association_3" {
    route_table_id=aws_route_table.private_route_table.id
    subnet_id=aws_subnet.private_subnet_3.id
}

resource "aws_eip" "elastic_ip_nat_gw" {
  vpc=true
  associate_with_private_ip="10.0.0.5"
  tags =  {
    Name = "Terraform-EIP"
  }
}

resource "aws_nat_gateway" "nat_gw" {
    allocation_id=aws_eip.elastic_ip_nat_gw.id
    subnet_id=aws_subnet.public_subnet_1.id
    tags = {
      Name = "Nat-GW"
    }
    depends_on=[aws_eip.elastic_ip_nat_gw]
}

resource "aws_route" "nat_gw_route" {
  route_table_id=aws_route_table.private_route_table.id
  nat_gateway_id=aws_nat_gateway.nat_gw.id
  destination_cidr_block="0.0.0.0/0"
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id=aws_vpc.tf_vpc.id
  tags = {
    Name = "Internet-GW"
  }
}

resource "aws_route" "internet_gw_route" {
  route_table_id=aws_route_table.public_route_table.id
  gateway_id=aws_internet_gateway.internet_gw.id
  destination_cidr_block="0.0.0.0/0"
}
