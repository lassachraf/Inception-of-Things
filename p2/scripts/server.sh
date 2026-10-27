#!/bin/bash

set -e

apt-get update -qq
apt-get install -y -qq curl

curl -sfL https://get.k3s.io | sh -s - server \
  --node-ip 192.168.56.110 \
  --flannel-iface eth1 \
  --write-kubeconfig-mode 644

  