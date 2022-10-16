#
# Install dependencies
#
apt install -y htop vim git sshpass curl wget 


#
# Setup NFS
#
apt install -y nfs-common
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
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose docker-compose-plugin
groupadd docker
gpasswd -a root docker
gpasswd -a cluster docker


#
# Machines fixs
#
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
sudo modprobe overlay
sudo modprobe br_netfilter







echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd




reboot now
