

#sudo rm /etc/kubernetes/manifests/kube-apiserver.yaml
#sudo rm /etc/kubernetes/manifests/kube-controller-manager.yaml
##sudo rm /etc/kubernetes/manifests/kube-scheduler.yaml
#sudo rm /etc/kubernetes/manifests/etcd.yaml
#sudo rm -rf /var/lib/etcd/member

#sudo kubeadm reset
#sudo kubeadm config images pull
#sudo kubeadm init

curl -sfL https://get.k3s.io | sh -s - server --disable servicelb --disable traefik

sudo chmod a+r /etc/rancher/k3s/k3s.yaml
mkdir -p /home/cluster/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/cluster/.kube/config
sudo chown cluster:cluster /home/cluster/.kube/config

echo "Use this token to join all worker nodes..."
sudo cat /var/lib/rancher/k3s/server/node-token