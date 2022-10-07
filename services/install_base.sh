#
# Install dependencies
#
sudo apt update
sudo apt install -y vim git htop curl gnupg sshpass 
sudo apt install -y ca-certificates lsb-release
sudo mkdir -p /etc/apt/keyrings


#
# Setup NFS
#
apt install -y nfs-common
mkdir /mnt/market_place
echo "10.1.1.202:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab

mkdir /mnt/volumes
echo "10.1.1.202:/volume1/volumes /mnt/volumes nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab

mkdir /mnt/homes
echo "10.1.1.202:/volume1/homes /mnt/homes nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab





echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system



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
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
groupadd docker
gpasswd -a root docker
gpasswd -a cluster docker


#
# Install fish
#
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_11/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_11/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
sudo apt update
sudo apt install -y fish
which fish


echo 'fish' >> /home/cluster/.bashrc

reboot now
