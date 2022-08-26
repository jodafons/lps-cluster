
# get name with ifconfig 
#device=$1
usermod -aG sudo $USER
echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
apt install net-tools

apt install -y vim resolvconf
# For LPS this should be 146.164.147.2
echo 'nameserver 146.164.147.2
search lps.ufrj.br' > /etc/resolvconf/resolv.conf.d/head
sudo service resolvconf restart

# for ubuntu
#echo "network:
#  version: 2
#  ethernets:
#     ens18:
#        dhcp4: false
#        addresses: [146.164.147.4/24]
#        gateway4: 146.164.147.1
#        nameservers:
#          addresses: [8.8.8.8, 8.8.4.4]" > 00-installer-config.yaml

echo "
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

auto ens18
iface ens18 inet static
  address 146.164.147.3
  netmask 255.255.255.0
  gateway 146.164.147.1
  dns-nameservers 146.164.147.2 8.8.8.8 8.8.8.4
" > /etc/network/interfaces

#sudo mv 00-installer-config.yaml /etc/netplan 
#netplan apply
systemctl restart networking
ifconfig
#sudo reboot now
reboot now