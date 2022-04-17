#!/bin/bash
kubectl create serviceaccount dashboard -n default
kubectl create clusterrolebinding dashboard-admin -n default --clusterrole=cluster-admin --serviceaccount=default:dashboard


helm repo add k8s-dashboard https://kubernetes.github.io/dashboard
helm repo update
helm install my-kubernetes-dashboard k8s-dashboard/kubernetes-dashboard --version 5.2.0 
kubectl get secret $(kubectl get serviceaccount dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode > ~/token-dashboard.txt
cat ~/token-dashboard.txt