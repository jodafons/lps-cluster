# install bind9
sudo apt-get update
sudo apt-get install -y net-tools bind9 bind9utils bind9-doc
sudo mkdir -p /etc/bind/zones

# copy configuration
cp files/bind9 /etc/default
source update.sh

systemctl restart bind9
sudo apt install -y ufw
sudo ufw allow Bind9


echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_11/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_11/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
sudo apt update
sudo apt install -y fish
which fish
echo 'fish' >> /home/cluster/.bashrc


