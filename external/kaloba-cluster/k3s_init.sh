curl -sfL https://get.k3s.io | sh -s - server --docker

sudo chmod a+r /etc/rancher/k3s/k3s.yaml
mkdir -p /home/cluster/.kube
mkdir -p /home/kube/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/cluster/.kube/config
sudo cp /etc/rancher/k3s/k3s.yaml /home/kube/.kube/config

sudo chown cluster:cluster /home/cluster/.kube/config
sudo chown kube:kube /home/cluster/.kube/config

echo "Use this token to join all worker nodes..."
sudo cat /var/lib/rancher/k3s/server/node-token