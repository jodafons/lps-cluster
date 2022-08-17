sudo cp zones/db.external /etc/bind/zones/
sudo cp zones/db.private /etc/bind/zones/
sudo cp zones/db.lps.ufrj.br /etc/bind/zones/
sudo cp zones/db.sandbox /etc/bind/zones/
sudo cp named.conf.options /etc/bind/
sudo cp named.conf.local /etc/bind/
systemctl restart bind9