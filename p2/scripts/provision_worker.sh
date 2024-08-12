export TOKEN_FILE="/vagrant/token/node-token"
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent --server https://192.168.56.110:6443 --token-file $TOKEN_FILE  --node-ip=192.168.56.111" sh -
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh
