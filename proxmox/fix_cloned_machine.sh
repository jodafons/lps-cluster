
hostname=$1
node_number=$2


#
# cluster as sudo with no password
#

usermod -aG sudo $USER
echo "cluster ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/cluster
apt install net-tools

#
# change hostname
#

hostnamectl set-hostname $hostname

echo "127.0.0.1       localhost
127.0.1.1       $hostname.lps.ufrj.br    hostname

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
" > /etc/hosts

hostnamectl



#
# Change IP
#

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
  address 10.1.1.$node_number
  gateway 10.1.1.1
  netmask 255.255.255.0
  dns-nameservers 146.164.147.2 8.8.8.8 8.8.8.4
" > /etc/network/interfaces

#netplan apply
systemctl restart networking
ifconfig



#
# fix ssh keys
#
dpkg-reconfigure openssh-server

#sudo reboot now
reboot now
