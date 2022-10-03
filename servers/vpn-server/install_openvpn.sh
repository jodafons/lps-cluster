

docker-compose run --rm openvpn ovpn_genconfig -u udp://146.164.147.6:3000
docker-compose run --rm openvpn ovpn_initpki
sudo chown -R $(whoami): $HOME/openvpn-data
docker-compose up -d openvpn
