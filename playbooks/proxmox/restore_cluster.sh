
export ANSIBLE_HOST_KEY_CHECKING=False
#
# reset all physical nodes
#
ansible-playbook -i hosts scripts/reset_node.yaml -e "hostgroup=gpu" 
ansible-playbook -i hosts scripts/reset_node.yaml -e "hostgroup=gpu-large" 
ansible-playbook -i hosts scripts/reset_node.yaml -e "hostgroup=cpu-large" 
ansible-playbook -i hosts scripts/create_cluster.yaml -e "hostname=caloba-v02 clustername=gpu"
ansible-playbook -i hosts scripts/create_cluster.yaml -e "hostname=caloba-v08 clustername=gpu-large"
ansible-playbook -i hosts scripts/create_cluster.yaml -e "hostname=caloba-v13 clustername=cpu-large"
sleep 5
ansible-playbook -i hosts scripts/create_node.yaml -vv -e "hostgroup=gpu clusterip=10.1.1.102 masterkey=$CALOBA_MASTER_KEY"
ansible-playbook -i hosts scripts/create_node.yaml -vv -e "hostgroup=gpu-large clusterip=10.1.1.108 masterkey=$CALOBA_MASTER_KEY"
ansible-playbook -i hosts scripts/create_node.yaml -vv -e "hostgroup=cpu-large clusterip=10.1.1.113 masterkey=$CALOBA_MASTER_KEY"
