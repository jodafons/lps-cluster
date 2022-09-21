sudo docker stop $(docker ps -a -q)
sudo docker rm -f $(docker ps -a -q)
sudo docker rmi -f $(docker images -a -q)
#sudo docker container prune -f
sudo docker images prune -a
sudo docker volume prune -f
sudo docker volume rm $(docker volume ls -q)
#sudo docker rmi -f $(docker images -a -q)
