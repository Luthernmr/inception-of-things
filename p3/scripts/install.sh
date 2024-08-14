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
    k3d cluster create my-cluster
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

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl port-forward -n argocd svc/argocd-server 8080:443

#TODO 



# Keep the shell open (optional)
exec "$SHELL"
