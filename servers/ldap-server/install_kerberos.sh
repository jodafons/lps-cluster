

sudo apt install -y vim resolvconf

# For LPS this should be 146.164.147.2
echo 'nameserver 192.168.0.200' > head
sudo mv head /etc/resolvconf/resolv.conf.d/
sudo service resolvconf restart

sudo dpkg-reconfigure debconf # Dialog and Low priority as input in textbox

sudo apt install -y krb5-{admin-server,kdc}




