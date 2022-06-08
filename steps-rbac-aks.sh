#!/bin/bash
# Gerar chave privada
openssl genrsa -out dev.key 2048
# Gerar CSR 
openssl req -new -key dev.key -out dev.csr -subj "/CN=dev/O=devs"
# Converter csr para base 64
cat dev.csr | base64 | tr -d '\n'
# Criar função para dev
kubectl apply -f role-devs.yaml
# Atribuir função 
kubectl apply -f binding-devs.yaml
# Converter certificado em base64
kubectl get csr dev-csr -n development -o jsonpath='{.status.certificate}' | base64 -d > dev-csr.pem
kubectl config set-credentials dev --client-key dev.key --client-certificate dev.pem --embed-certs=true
kubectl config set-context dev --cluster=aks-cluster --user=dev
kubectl config use-context dev
kubectl config unset users.aks-group_aks-cluster
