
hostname=$1
IP=$2




usermod -aG sudo $USER
echo "cluster ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/cluster
apt install -y net-tools

hostnamectl set-hostname $hostname

#
# Change IP
#
echo "
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto ens18
iface ens18 inet static
        address 146.164.147.$IP
        gateway 146.164.147.1
        dns-nameservers 146.164.147.2 8.8.8.8 8.8.8.4
"> /etc/network/interfaces

#netplan apply
systemctl restart networking

#
# resolv conf
#
apt install -y resolvconf
# For LPS this should be 146.164.147.2
echo 'nameserver 146.164.147.2
search lps.ufrj.br' > /etc/resolvconf/resolv.conf.d/head
service resolvconf restart

reboot now