

sudo rm /etc/kubernetes/manifests/kube-apiserver.yaml
sudo rm /etc/kubernetes/manifests/kube-controller-manager.yaml
sudo rm /etc/kubernetes/manifests/kube-scheduler.yaml
sudo rm /etc/kubernetes/manifests/etcd.yaml
sudo rm -rf /var/lib/etcd/member

sudo kubeadm config images pull
sudo kubeadm init

mkdir -p $HOME/.kube sudo 
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config 
sudo chown $(id -u):$(id -g) $HOME/.kube/config