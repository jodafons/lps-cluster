# install bind9
sudo apt-get update
sudo apt-get install -y bind9 bind9utils bind9-doc
sudo mkdir -p /etc/bind/zones
source update.sh

# copy configuration
echo 's/OPTIONS=.*/OPTIONS="-4 -u bind"/' > bind9
sudo mv bind9 /etc/default
sudo cp zones/* /etc/bind/zones/
sudo cp named.conf.local /etc/bind/

named-checkconf
named-checkzone sandbox.ufrj.br /etc/bind/zones/db.sandbox

systemctl restart bind9
sudo apt install -y ufw
sudo ufw allow Bind9

