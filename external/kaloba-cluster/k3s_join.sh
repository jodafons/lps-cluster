MASTERNODE_TOKEN=$2
MASTERNODE_IP=$1

curl -sfL https://get.k3s.io | K3S_URL=https://$MASTERNODE_IP:6443 K3S_TOKEN=$MASTERNODE_TOKEN sh -