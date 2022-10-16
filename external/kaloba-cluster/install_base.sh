#
# Install dependencies
#
apt install -y htop vim git sshpass ansible curl wget 


#
# Setup NFS
#
apt install -y nfs-common
mkdir /mnt/market_place
echo "10.1.1.202:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
mkdir /mnt/kubernetes
echo "10.1.1.202:/volume1/kubernetes /mnt/kubernetes nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab


#
# Install docker
#
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg


echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
groupadd docker
gpasswd -a root docker
gpasswd -a cluster docker



#
# Install kubernetes
#
apt install -y gnupg2
apt -y install curl apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt update
apt -y install kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl


#
# Machines fixs
#
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sudo sysctl --system
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
reboot now

