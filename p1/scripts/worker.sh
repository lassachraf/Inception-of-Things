#!/bin/bash

set -e

apt-get update -qq
apt-get install -y -qq curl

export K3S_TOKEN="iot-secret-token"
export K3S_URL="https://192.168.56.110:6443"
export INSTALL_K3S_EXEC="agent --node-ip 192.168.56.111 --flannel-iface eth1"

curl -sfL https://get.k3s.io | sh -