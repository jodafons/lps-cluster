
IP=$1

usermod -aG sudo $USER
echo "cluster ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/cluster
apt install -y net-tools


sudo apt install -y resolvconf
# For LPS this should be 146.164.147.2
echo 'nameserver 146.164.147.2
search lps.ufrj.br' > head
sudo mv head /etc/resolvconf/resolv.conf.d/
sudo service resolvconf restart


echo "network:
  version: 2
  ethernets:
     ens18:
        dhcp4: false
        addresses: [146.164.147.$IP/24]
        gateway4: 146.164.147.1
        nameservers:
          addresses: [8.8.8.8, 8.8.4.4, 146.164.147.2]" > 00-installer-config.yaml

sudo mv 00-installer-config.yaml /etc/netplan 
sudo netplan apply
ifconfig



#
# resolv conf
#
apt install -y resolvconf
# For LPS this should be 146.164.147.2
echo 'nameserver 146.164.147.2
search lps.ufrj.br' > /etc/resolvconf/resolv.conf.d/head
service resolvconf restart


reboot now