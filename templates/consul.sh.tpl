#!/usr/bin/env bash
set -e

echo "Grabbing IPs..."
PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

echo "Installing dependencies..."
sudo apt-get -qq update &>/dev/null
sudo apt-get -yqq install unzip &>/dev/null

echo "Fetching Consul..."
cd /tmp
curl -sLo consul.zip https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip

echo "Installing Consul..."
unzip consul.zip >/dev/null
sudo chmod +x consul
sudo mv consul /usr/local/bin/consul

# Setup Consul
sudo mkdir -p /mnt/consul
sudo mkdir -p /etc/consul.d
sudo tee /etc/consul.d/config.json > /dev/null <<EOF
{
  "bind_addr": "$PRIVATE_IP",
  "advertise_addr": "$PRIVATE_IP",
  "advertise_addr_wan": "$PUBLIC_IP",
  "data_dir": "/mnt/consul",
  "disable_remote_exec": true,
  "disable_update_check": true,
  "leave_on_terminate": true,
  ${config}
}
EOF

sudo tee /etc/init/consul.conf > /dev/null <<"EOF"
description "Consul"
start on runlevel [2345]
stop on runlevel [06]
respawn
post-stop exec sleep 5
# This is to avoid Upstart re-spawning the process upon `consul leave`
normal exit 0 INT
# Stop consul will not mark node as failed but left
kill signal INT
exec /usr/local/bin/consul agent \
  -config-dir="/etc/consul.d"
EOF

sudo service consul stop || true
sudo service consul start
