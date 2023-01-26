#
# Install dependencies
#
apt install -y htop vim git sshpass curl wget rsync


#
# Setup NFS
#
apt install -y nfs-common

mkdir /mnt/seixas1
mkdir /mnt/storage1
mkdir /mnt/storage2
mkdir /mnt/storage3
mkdir /mnt/storage4

echo "10.1.1.201:/volume1 /mnt/seixas1 nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
echo "10.1.1.202:/volume1 /mnt/storage1 nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
echo "10.1.1.204:/shares /mnt/storage3 nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab
#echo "10.1.1.204:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab


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
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
groupadd docker
gpasswd -a root docker
gpasswd -a cluster docker



reboot now
