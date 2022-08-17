
IP=$1
GW=$2

echo "network:
  version: 2
  ethernets:
     enp0s3:
        dhcp4: false
        addresses: [$IP/24]
        gateway4: $GW
        nameservers:
          addresses: [8.8.8.8, 8.8.4.4]" > 00-installer-config.yaml

sudo mv 00-installer-config.yaml /etc/netplan 
sudo netplan apply
ifconfig