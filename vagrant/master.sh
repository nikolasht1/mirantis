#!/bin/bash
echo "Initialize Kubeadm On Master Node To Setup Control Plane"
echo "verify ip adress"
IPADDR="10.0.0.10"
echo "inpost node_name"
NODENAME=$(hostname -s)

#Now, initialize the master node control plane configurations using the following kubeadm command
echo "initialize the master node control plane configurations using the following kubeadm command"
sudo kubeadm init --apiserver-advertise-address=$IPADDR  --apiserver-cert-extra-sans=$IPADDR  --pod-network-cidr=192.168.0.0/16 --node-name $NODENAME --v=5

#copi admin-config
echo "make directorie"
mkdir -p $HOME/.kube
echo "copy config"
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
echo "make permision"
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo "register curl"
curl https://docs.projectcalico.org/manifests/calico.yaml -O

#list all the pods in the kube-system namespace
#kubectl get po -n kube-system


# install the calico network plugin on the cluster
echo "install the calico network plugin on the cluster"
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl apply -f calico.yaml
echo "show active node"
kubectl get po -n kube-system

#Join Worker Nodes To Kubernetes Master Node
#kubeadm token create --print-join-command
#Then you can join any number of worker nodes by running the following on each as root:

#kubectl get nodes
echo "install metrics"
kubectl apply -f https://raw.githubusercontent.com/scriptcamp/kubeadm-scripts/main/manifests/metrics-server.yaml

echo "show token"
kubeadm token create --print-join-command

echo "show metrics"
kubectl top nodes

#install Helm for ubuntu
#curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
#sudo apt-get install apt-transport-https --yes
#echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
#sudo apt-get update
#sudo apt-get install helm

#initialize Helm
#helm
#helm repo add stable https://charts.helm.sh/stable

#install jenkins using helm
#helm search repo stable/jenkins
#helm search repo hub jenkins
#helm repo add jenkins https://artifacthub.io/packages/helm/edu/jenkins 

#helm install --namespace jenkins -f jenkins/demo-values.yaml stable/jenkins

#kubectl create clusterrolebinding jenkins --clusterrole cluster-admin --serviceaccount=jenkins:default

