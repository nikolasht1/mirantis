#!/bin/bash


#Initialize Kubeadm On Master Node To Setup Control Plane

IPADDR="10.0.0.10"

NODENAME=$(hostname -s)

#Now, initialize the master node control plane configurations using the following kubeadm command

sudo kubeadm init --apiserver-advertise-address=$IPADDR  --apiserver-cert-extra-sans=$IPADDR  --pod-network-cidr=192.168.0.0/16 --node-name $NODENAME --v=5

#copi admin-config

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

curl https://docs.projectcalico.org/manifests/calico.yaml -O

#list all the pods in the kube-system namespace
#kubectl get po -n kube-system


# install the calico network plugin on the cluster
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
kubectl apply -f calico.yaml

#kubectl get po -n kube-system

#Join Worker Nodes To Kubernetes Master Node
#kubeadm token create --print-join-command
#Then you can join any number of worker nodes by running the following on each as root:

#kubectl get nodes

#kubectl apply -f https://raw.githubusercontent.com/scriptcamp/kubeadm-scripts/main/manifests/metrics-server.yaml
#kubectl top nodes

#install Helm for ubuntu
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

#initialize Helm
#helm
#helm repo add stable https://charts.helm.sh/stable

#install jenkins using helm
#helm search repo stable/jenkins
#helm search repo hub jenkins
#helm repo add jenkins https://artifacthub.io/packages/helm/edu/jenkins 

#helm install --namespace jenkins -f jenkins/demo-values.yaml stable/jenkins

#kubectl create clusterrolebinding jenkins --clusterrole cluster-admin --serviceaccount=jenkins:default
<<comment
no pasword user vagrant
vagrant ALL=(ALL) NOPASSWD:ALL

info get
https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/
###############################
info cluster
kubectl config get-contexts
kubectl cluster-info

kubernetes dashboard setings
edit port in service(svc) <ClusterIp, NodePort, LoadBalancer>
kubectl -n default edit svc my-release-kubernetes-dashboard
kubectl create serviceaccount dashboard -n default
kubectl create clusterrolebinding dashboard-admin -n default --clusterrole=cluster-admin --serviceaccount=default:dashboard
kubectl get secret $(kubectl get serviceaccount dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode > ~/token-dashboard.txt
#command on the master node baremetal
#kubectl logs -f my-release-nginx-ingress-865865d656-rsv5n -n ingres-nginx
#kubectl get svc -n ingres-nginx
#kubectl get po -n ingres-nginx
#kubectl create ns ingres-nginx
helm install my-release nginx-stable/nginx-ingress -n ingres-nginx
#kubectl get po -n kube-system
#In my case I've patched the service like this:
#kubectl patch svc <svc-name> -n <namespace> -p '{"spec": {"type": "LoadBalancer", "externalIPs":["172.31.71.218"]}}'
kubectl patch svc my-release-nginx-ingress -n nginx-ingress -p '{"spec": {"type": "LoadBalancer", "externalIPs":["10.0.0.10"]}}'
#kubectl apply -f test3-deployment.yaml
#kubectl apply -f test1-ingres.yaml
# kubectl get ing -A    shou ingress 
#kubectl get po -n test1 -o wide

#view my kluster
 kubectl config get-contexts

#view pod and HESH
 kubectl get po -n nginx-ingress

 kubectl get svc -n nginx-ingress

view log in namespace
kubectl logs -f my-release-nginx-ingress-69bcd48978-8f4kt -n nginx-ingress

view all svc
kubectl get svc -A
kubectl get svc --all-namespaces -o wide

create namespace 
kubectl create ns my-domain1 my-domain2 my-domain3

apply deployment
kubectl apply -f /vagrant/nginx_ingress/my-domain1-deployment.yaml

view pods
kubectl get po -n my-domain1

apply ingress
kubectl apply -f /vagrant/nginx_ingress/my-domain1-ingress.yaml


kubectl delete svc --namespace=my-domain3 my-domain3-service

check domain 
dig my-domain1
kubectl get ing -A

view service info
kubectl describe svc mytest1-service -n mytest1

enter in pod
kubectl exec -it mytest1-7fccc9894f-zk6s5 bash -n mytest1
apt-get update
apt-get install net-tools
netstat -ntlp

get deploiment
kubectl get -n jenkinslts svc -w jenkins-service   
kubectl get deployment mytest1 -n mytest1
kubectl edit deployment mytest1 -n mytest1
view ip pods
kubectl get po -n mytest1 -o wide
kubectl describe po -n mytest1 | grep IP

get page in to pod 
curl -I localhost
read page in to pod
curl localhost

test ties pod service
curl mytest1-service

test ties ingres service
kubectl get ing -n mytest1
kubectl get mytest1-ingress -n mytest1
kubectl get ing -A | grep mytest1
kubectl get po -A | grep ingres
kubectl get ing mytest1-ingress -o yaml -n mytest1
kubectl logs my-release-nginx-ingress-69bcd48978-8qqmg -n ingres-nginx --since 10m
kubectl get svc -n mytest1
kubectl describe svc mytest1-service -n mytest1

get all resources namespaces
 kubectl get all -n k8sdashbord

change value chart in helm instalation
helm show values kubeview/kubeview --version 0.1.31
helm install metallb metallb/metallb -f ~/metallb/values.yaml -n metallbns

command instal on the specific node
kubectl run --image=nginx:latest nginx \
    --overrides='{"apiVersion": "v1", "spec": {"nodeSelector": { "kubernetes.io/hostname": "ip-174-163.kryukov.local" }}}'

for generate key
- ssh-keygen
validate key
- eval $(ssh-agent -s)
clip < ~/.ssh/id_rsa.pub
ssh-copy-id 
ssh-copy-id jenkins@ip
cat ~/.ssh/id_rsa.pub | ssh jenkins@10.0.0.10 " cat >> ~/.ssh/authorized_keys"
chmod:
.ssh 700
.pub 644
key 600

see and create yaml file 
minikube kubectl -- create deploy my-nginx --image nginx --dry-ryn -o yaml

comment