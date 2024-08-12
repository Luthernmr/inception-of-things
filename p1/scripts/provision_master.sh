curl -sfL https://get.k3s.io |  INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --node-ip 192.168.56.110  --bind-address=192.168.56.110 --advertise-address=192.168.56.110" sh -
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh
mkdir -p /vagrant/token
cp /var/lib/rancher/k3s/server/node-token /vagrant/token