#!/bin/bash

IPADDR="10.0.0.10"

NODENAME=$(hostname -s)

#Now, initialize the master node control plane configurations using the following kubeadm command

sudo kubeadm init --apiserver-advertise-address=$IPADDR  --apiserver-cert-extra-sans=$IPADDR  --pod-network-cidr=192.168.0.0/16 --node-name $NODENAME --v=5

#copy admin-config

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#curl https://docs.projectcalico.org/manifests/calico.yaml -O

# install the calico network plugin on the cluster
#kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
#kubectl apply -f calico.yaml

#install wave on cluster
#kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
#kubectl describe nodes

#Join Worker Nodes To Kubernetes Master Node
#kubeadm token create --print-join-command
#Then you can join any number of worker nodes by running the following on each as root:
#delete namespace
#kubectl delete ns <namespace>
#kubectl get nodes

#kubectl apply -f https://raw.githubusercontent.com/scriptcamp/kubeadm-scripts/main/manifests/metrics-server.yaml
#kubectl top nodes

#install Helm for ubuntu
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

sudo apt-get update
sudo apt-get install helm

#kubeadm token create --print-join-command in shared directory

sudo kubeadm token create --print-join-command > /vagrant/joincluster.sh

#create permision for vagrant user
mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config

helm repo add projectcalico https://projectcalico.docs.tigera.io/charts
helm repo update
helm install calico projectcalico/tigera-operator --version v3.22.1
#helm install calico projectcalico/tigera-operator --version v3.22.1 -f values.yaml




<<comment
#add ingress to cluster
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
kubectl create ns nginx-ingress
helm install my-release nginx-stable/nginx-ingress -n nginx-ingress
comment