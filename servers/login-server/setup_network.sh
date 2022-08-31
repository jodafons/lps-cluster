
# get name with ifconfig 
#device=$1
usermod -aG sudo cluster
echo "cluster ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/cluster
apt install net-tools

apt install -y vim resolvconf
# For LPS this should be 146.164.147.2
echo 'nameserver 146.164.147.2
search lps.ufrj.br' > /etc/resolvconf/resolv.conf.d/head
sudo service resolvconf restart



echo "
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

auto enp6s18
iface enp6s18 inet static
  address 146.164.147.5
  netmask 255.255.255.0
  gateway 146.164.147.1
  dns-nameservers 146.164.147.2 8.8.8.8 8.8.8.4
" > /etc/network/interfaces

#sudo mv 00-installer-config.yaml /etc/netplan 
#netplan apply
systemctl restart networking
ifconfig


#
# Append market_place into the mount
#

apt install -y nfs-common
mkdir /mnt/market_place
echo "10.1.1.202:/volume1/market_place /mnt/market_place nfs rsize=32768,wsize=32768,bg,sync,nolock 0 0" >> /etc/fstab


#sudo reboot now
reboot now