docker stop $(docker ps -a -q)
docker container prune
docker images prune -a
docker volume prune
docker volume rm -f $(docker volume ls -q)

docker rmi -f $(docker images -a -q)

rm -rf /etc/ceph       
rm -rf /etc/cni        
rm -rf /etc/kubernetes        
rm -rf /opt/cni        
rm -rf /opt/rke        
rm -rf /run/secrets/kubernetes.io        
rm -rf /run/calico        
rm -rf /run/flannel        
rm -rf /var/lib/calico        
rm -rf /var/lib/etcd        
rm -rf /var/lib/cni        
rm -rf /var/lib/kubelet        
rm -rf /var/lib/rancher/rke/log        
rm -rf /var/log/containers        
rm -rf /var/log/kube-audit        
rm -rf /var/log/pods        
rm -rf /var/run/calico