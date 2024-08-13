curl -sfL https://get.k3s.io |  INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --node-ip 192.168.56.110  --bind-address=192.168.56.110 --advertise-address=192.168.56.110" sh -

echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh

kubectl create namespace app1
kubectl create namespace app2
kubectl create namespace app3

kubectl apply -f /vagrant/apps
