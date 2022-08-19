
# get name with ifconfig 
device=$1
echo "network:
  version: 2
  ethernets:
     $device:
        dhcp4: false
        addresses: [146.164.147.2/24]
        gateway4: 146.164.147.1
        nameservers:
          addresses: [8.8.8.8, 8.8.4.4]" > 00-installer-config.yaml

sudo mv 00-installer-config.yaml /etc/netplan 
sudo netplan apply
ifconfig
