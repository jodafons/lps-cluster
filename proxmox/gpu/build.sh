

#ansible-playbook -i hosts reset_node.yaml 
#ansible-playbook -i hosts create_cluster.yaml -e "host_name=caloba-v01 cluster_name=gpu"
#ansible-playbook -i hosts create_node.yaml -vv -e "host_group=gpu cluster_ip=10.1.1.101 cluster_password=$MASTER_PASSWORD"
#ansible-playbook -i hosts create_node.yaml -vv -e "host_group=gpu cluster_ip=10.1.1.101 cluster_password=$MASTER_PASSWORD"



