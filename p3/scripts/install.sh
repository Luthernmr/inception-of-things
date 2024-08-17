#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Docker if not installed
if ! command_exists docker; then
    echo "Docker is not installed. Installing Docker..."
    sudo apt update
    sudo apt install -y docker.io
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
else
    echo "Docker is already installed. Skipping..."
fi

# Install K3d if not installed
if ! command_exists k3d; then
    echo "K3d is not installed. Installing K3d..."
    wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
else
    echo "K3d is already installed. Skipping..."
fi

# Install Kubectl if not installed
if ! command_exists kubectl; then
    echo "Kubectl is not installed. Installing Kubectl..."
    curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
    chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl
    kubectl version --client
else
    echo "Kubectl is already installed. Skipping..."
fi

# Create K3d cluster if not already created
if ! k3d cluster list | grep -q "my-cluster"; then
    echo "Creating K3d cluster named 'my-cluster'..."
    k3d cluster create my-cluster \
    -p 8443:8443@loadbalancer \
    -p 8181:8181@loadbalancer \
    -p 8888:8888@loadbalancer \
    -p 8989:8989@loadbalancer
else
    echo "K3d cluster my-cluster already exists. Skipping..."
fi

# Get kubeconfig and save it to ~/.kube/config
if [ ! -d "$HOME/.kube" ]; then
    mkdir ~/.kube
fi

k3d kubeconfig get -a > ~/.kube/config
echo "Kubeconfig saved to ~/.kube/config"

# Deploy argocd on the cluster
kubectl create namespace argocd
kubectl create namespace dev


kubectl apply -n argocd -f ../confs/install.yaml
kubectl apply -n argocd -f ../confs/application-will-app.yaml

kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}' #change Service type to Loadbalcer
sleep 60s

echo -e "argocd host: localhost:8443\n"
echo -e "argocd user: admin\n"
echo "argocd password: "
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo -e "\n" 
echo -e"will app: localhost:8888\n"


