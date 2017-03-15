# Create the user-data for the Consul server
data "template_file" "server" {
  count    = "${var.servers}"
  template = "${file("${path.module}/templates/consul.sh.tpl")}"

  vars {
    consul_version = "0.7.5"

    config = <<EOF
     "bootstrap_expect": 3,
     "node_name": "${var.namespace}-server-${count.index}",
     "retry_join_ec2": {
       "tag_key": "${var.consul_join_tag_key}",
       "tag_value": "${var.consul_join_tag_value}"
     },
     "server": true
    EOF
  }
}

# Create the user-data for the Consul server
data "template_file" "client" {
  count    = "${var.clients}"
  template = "${file("${path.module}/templates/consul.sh.tpl")}"

  vars {
    consul_version = "0.7.5"

    config = <<EOF
     "node_name": "${var.namespace}-client-${count.index}",
     "retry_join_ec2": {
       "tag_key": "${var.consul_join_tag_key}",
       "tag_value": "${var.consul_join_tag_value}"
     },
     "server": false
    EOF
  }
}

# Create the Consul cluster
resource "aws_instance" "server" {
  count = "${var.servers}"

  ami           = "${data.aws_ami.ubuntu-1404.id}"
  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.consul.id}"

  subnet_id              = "${element(aws_subnet.consul.*.id, count.index)}"
  iam_instance_profile   = "${aws_iam_instance_profile.consul-join.name}"
  vpc_security_group_ids = ["${aws_security_group.consul.id}"]

  tags = "${map(
    "Name", "${var.namespace}-server-${count.index}",
    var.consul_join_tag_key, var.consul_join_tag_value
  )}"

  user_data = "${element(data.template_file.server.*.rendered, count.index)}"
}

resource "aws_instance" "client" {
  count = "${var.clients}"

  ami           = "${data.aws_ami.ubuntu-1404.id}"
  instance_type = "${var.instance_type}"
  key_name      = "${aws_key_pair.consul.id}"

  subnet_id              = "${element(aws_subnet.consul.*.id, count.index)}"
  iam_instance_profile   = "${aws_iam_instance_profile.consul-join.name}"
  vpc_security_group_ids = ["${aws_security_group.consul.id}"]

  tags = "${map(
    "Name", "${var.namespace}-client-${count.index}",
    var.consul_join_tag_key, var.consul_join_tag_value
  )}"

  user_data = "${element(data.template_file.client.*.rendered, count.index)}"
}

output "servers" {
  value = ["${aws_instance.server.*.public_ip}"]
}

output "clients" {
  value = ["${aws_instance.client.*.public_ip}"]
}
