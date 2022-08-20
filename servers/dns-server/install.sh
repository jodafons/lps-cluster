# install bind9
sudo apt-get update
sudo apt-get install -y net-tools bind9 bind9utils bind9-doc
sudo mkdir -p /etc/bind/zones

# copy configuration
echo 's/OPTIONS=.*/OPTIONS="-4 -u bind"/' > bind9
sudo mv bind9 /etc/default
source update.sh

systemctl restart bind9
sudo apt install -y ufw
sudo ufw allow Bind9

