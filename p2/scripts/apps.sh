#!/bin/bash
set -e

echo "Waiting for K3s to be ready..."
until kubectl get nodes 2>/dev/null | grep -q " Ready"; do
  sleep 3
done

kubectl apply -f /vagrant/confs/
