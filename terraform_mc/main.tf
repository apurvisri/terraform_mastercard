provider "aws" {
  region  = "ap-south-1" # Mumbai
}

resource "aws_vpc" "web_vpc" {
  cidr_block           = "192.168.100.0/24"
  enable_dns_hostnames = true

  tags = {
    Name = "Web_VPC"
  }
}

resource "aws_subnet" "web_subnet" {
  # Use the count meta-parameter to create multiple copies
  count             = 2
  vpc_id            = aws_vpc.web_vpc.id
  # cidrsubnet function splits a cidr block into subnets
  cidr_block        = cidrsubnet(var.network_cidr, 2, count.index)
  # element retrieves a list element at a given index
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "Web_Subnet ${count.index + 1}"
  }
}

data "template_file" "user_data" {
  template = file("user_data.sh")
}

resource "aws_instance" "web" {
  count                  = var.instance_count
  # lookup returns a map value for a given key
  ami                    = lookup(var.ami_ids, "ap-south-1")
  instance_type          = "t2.micro"
  # Use the subnet ids as an array and evenly distribute instances
  subnet_id              = element(aws_subnet.web_subnet.*.id, count.index % length(aws_subnet.web_subnet.*.id))

  # Use instance user_data to serve the custom website
   user_data              = file("user_data.sh")

  # Attach the web server security group
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = { 
    Name = "Web_Server ${count.index + 1}"
  }
}

 resource "aws_ebs_volume" "my_volume" {
    count                 = var.instance_count
    availability_zone = element(var.availability_zones, count.index)
    size              = 1
    tags = {
        Name = "webserver-pd"
    }
}

 resource "aws_volume_attachment" "ebs_attachment" {
    count                  = var.instance_count
    device_name = "/dev/xvdf"
    volume_id   =  aws_ebs_volume.my_volume.*.id[count.index]
    instance_id =  aws_instance.web.*.id[count.index]
    force_detach =true     
   depends_on=[ aws_ebs_volume.my_volume,aws_ebs_volume.my_volume]
}
