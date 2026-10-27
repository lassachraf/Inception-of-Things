#!/bin/bash

set -e

apt-get update -qq
apt-get install -y -qq curl

export K3S_TOKEN="iot-secret-token"
export INSTALL_K3S_EXEC="server --node-ip 192.168.56.110 --advertise-address 192.168.56.110 --flannel-iface eth1 --write-kubeconfig-mode 644"

curl -sfL https://get.k3s.io | sh -
