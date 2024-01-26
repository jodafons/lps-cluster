

#ansible-playbook -i hosts reset_node.yaml 
#ansible-playbook -i hosts create_cluster.yaml -e "host_name=caloba-v01 cluster_name=gpu"
#ansible-playbook -i hosts create_node.yaml -vv -e "host_group=gpu cluster_ip=10.1.1.101 cluster_password=$MASTER_PASSWORD"
#ansible-playbook -i hosts create_node.yaml -vv -e "host_group=gpu cluster_ip=10.1.1.101 cluster_password=$MASTER_PASSWORD"


image='/mnt/pve/storage01/dump/vzdump-qemu-270-2024_01_26-10_22_41.vma.zst'
ansible-playbook -i hosts restore_vm.yaml -vv -e "host_name=caloba-v03 image=$image vmid=270 node_name=caloba70"

