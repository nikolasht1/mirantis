#!/bin/bash

echo "disable swap"
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab


#Install the required packages for Docker
sudo apt-get update -y
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

#Add the Docker GPG key and apt repository

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Install the Docker community edition

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Following configurations are recomended in the kubenetes documentation for Docker runtime. Please refer https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker

#Add the docker daemon configurations to use systemd as the cgroup driver

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

#Start and enable the docker service

sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

echo "Install Kubeadm & Kubelet & Kubectl on all Nodes"
#Install the required dependencies

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

#Add the GPG key and apt repository

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

#Update apt and install kubelet, kubeadm and kubectl

sudo apt-get update -y
sudo apt-get install -y kubelet kubeadm kubectl