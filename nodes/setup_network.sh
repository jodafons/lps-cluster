
# get name with ifconfig 
NUMBER=$1


#usermod -aG sudo $USER
echo "cluster ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
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

auto ens18
iface ens18 inet static
  address 10.1.1.$NUMBER
  gateway 10.1.1.1
  netmask 255.255.255.0
  dns-nameservers 146.164.147.2 8.8.8.8 8.8.8.4
" > /etc/network/interfaces

#sudo mv 00-installer-config.yaml /etc/netplan 
#netplan apply
systemctl restart networking
ifconfig
#sudo reboot now
#reboot now
