
network_device=$1
hostname=$2
node_number=$3

#
# fix ssh keys
#
dpkg-reconfigure openssh-server


#
# Add the new machine into the kerberos
#
kadmin -q "addprinc -policy service -randkey host/$hostname.lps.ufrj.br"
kadmin -q "ktadd -k /etc/krb5.keytab host/$hostname.lps.ufrj.br"

#
# change hostname
#

hostnamectl set-hostname $hostname

echo "127.0.0.1       localhost
127.0.1.1       $hostname.lps.ufrj.br    $hostname
# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
" > /etc/hosts
hostnamectl


echo "
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

auto $network_device
iface $network_device inet static
  address 10.1.1.$node_number
  gateway 10.1.1.1
  dns-nameservers 146.164.147.2 8.8.8.8 8.8.8.4
" > /etc/network/interfaces

#netplan apply
systemctl restart networking
ifconfig




#sudo reboot now
reboot now
