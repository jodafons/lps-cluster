

ansible-playbook -i hosts reset_node.yaml 
ansible-playbook -i hosts create_cluster.yaml -e "hostname=caloba-v01 clustername=gpu"
ansible-playbook -i hosts create_node.yaml -vv -e "hostgroup=gpu clusterip=10.1.1.101 masterkey=$MASTER_KEY"
#ansible-playbook -i hosts create_node.yaml -vv -e "host_group=gpu cluster_ip=10.1.1.101 cluster_password=$MASTER_PASSWORD"



