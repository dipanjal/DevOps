#!/bin/bash

echo "This script is written to work with Ubuntu 20.04"
sleep 1

echo "*** Installation In Master ***"

sudo apt-get update && sudo apt-get upgrade -y

sleep 2
sudo apt install docker.io -y

sleep 1
sudo systemctl start docker

sleep 1
sudo systemctl enable docker

sleep 1
sudo usermod -aG docker $USER

echo "Installing dependencies for https and cURL"

sleep 1
sudo apt install apt-transport-https curl -y

sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet=1.20.2-00 kubeadm=1.20.2-00 kubectl=1.20.2-00
sudo apt-mark hold kubelet kubeadm kubectl

sleep 2
echo "Disable Swapoff Memory"
sudo swapoff -a

sleep 1
echo "Initialize Kubernetes Master Server"
sudo kubeadm init

sleep 2
echo "Running the steps explained at the end of the init output"
mkdir -p $HOME/.kube

sleep 2
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

sleep 2
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sleep 2
echo "Deploy Pod Network (WeaveNet)"
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
echo "Pod Network Installation Complete"

sleep 2
kubectl get nodes

echo "Script Finished"
