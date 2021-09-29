#! /bin/bash
kubectl get namespace

kubectl get service

kubectl create namespace devops-tools

kubectl get namespace

sudo vi serviceAccount.yaml

cat serviceAccount.yaml

kubectl apply -f serviceAccount.yaml

kubectl create -f volume.yaml

kubectl apply -f deployment.yaml

kubectl get deployments -n devops-tools

kubectl  describe deployments --namespace=devops-tools

kubectl apply -f service.yaml

kubectl get pods --namespace=devops-tools

kubectl logs jenkins-f7cd44db7-g6x6g --namespace=devops-tools