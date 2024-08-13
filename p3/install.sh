# install docker
sudo apt install docker.io
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

# install k3d
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# install Kubectl
curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client
# create cluster k3d
k3d cluster create mycluster

# get kubeconfig
mkdir ~/.kube
k3d kubeconfig get -a > ~/.kube/config