sudo cp zones/* /etc/bind/zones/
sudo cp named.conf.options /etc/bind/
sudo cp named.conf.local /etc/bind/
systemctl restart bind9
