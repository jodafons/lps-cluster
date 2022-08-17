sudo docker-compose down
sudo docker rm -f $(docker ps -a -q)
sudo docker-compose up -d