

docker-compose run --rm openvpn ovpn_genconfig -u udp://146.164.147.6
docker-compose run --rm openvpn ovpn_initpki
sudo chown -R $(whoami): ./openvpn-data
docker-compose up -d openvpn
