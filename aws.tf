# Get the list of official Canonical Ubunt 14.04 AMIs
data "aws_ami" "ubuntu-1404" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create a VPC to launch our instances into
resource "aws_vpc" "consul" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true

  tags {
    "Name" = "${var.namespace}"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "consul" {
  vpc_id = "${aws_vpc.consul.id}"

  tags {
    "Name" = "${var.namespace}"
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.consul.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.consul.id}"
}

# Grab the list of availability zones
data "aws_availability_zones" "available" {}

# Create a subnet to launch our instances into
resource "aws_subnet" "consul" {
  count                   = "${length(var.cidr_blocks)}"
  vpc_id                  = "${aws_vpc.consul.id}"
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block              = "${var.cidr_blocks[count.index]}"
  map_public_ip_on_launch = true

  tags {
    "Name" = "${var.namespace}"
  }
}

# A security group that makes the instances accessible
resource "aws_security_group" "consul" {
  name_prefix = "${var.namespace}"
  vpc_id      = "${aws_vpc.consul.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "consul" {
  key_name   = "${var.namespace}"
  public_key = "${file("${var.public_key_path}")}"
}

# Create an IAM role for the auto-join
resource "aws_iam_role" "consul-join" {
  name               = "${var.namespace}-consul-join"
  assume_role_policy = "${file("${path.module}/templates/policies/assume-role.json")}"
}

# Create the policy
resource "aws_iam_policy" "consul-join" {
  name        = "${var.namespace}-consul-join"
  description = "Allows Consul nodes to describe instances for joining."
  policy      = "${file("${path.module}/templates/policies/describe-instances.json")}"
}

# Attach the policy
resource "aws_iam_policy_attachment" "consul-join" {
  name       = "${var.namespace}-consul-join"
  roles      = ["${aws_iam_role.consul-join.name}"]
  policy_arn = "${aws_iam_policy.consul-join.arn}"
}

# Create the instance profile
resource "aws_iam_instance_profile" "consul-join" {
  name  = "${var.namespace}-consul-join"
  roles = ["${aws_iam_role.consul-join.name}"]
}
