hostname=$1

hostnamectl set-hostname $hostname

echo "127.0.0.1       localhost
127.0.1.1       $hostname.lps.ufrj.br    $hostname
# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
" > /etc/hosts
hostnamectl

#reboot now