# Data Source to Get Existing VPC
data "aws_vpc" "existing" {
  filter {
    name   = "tag:Name"
    values = ["my-vpc-meshy"]
  }
}


data "aws_availability_zones" "available" {}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.eks_cluster_name}-vpc"
  }
}

resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name = "${var.eks_cluster_name}-private-subnet-${count.index+1}"
  }
}

