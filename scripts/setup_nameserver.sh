sudo apt install -y vim resolvconf

# For LPS this should be 146.164.147.2
echo 'nameserver 192.168.0.200' > head
sudo mv head /etc/resolvconf/resolv.conf.d/