

#ansible-playbook -i hosts reset_node.yaml 
#ansible-playbook -i hosts create_cluster.yaml -e "host_name=caloba-v01 cluster_name=gpu"
#ansible-playbook -i hosts create_node.yaml -e "host_group=gpu cluster_ip=10.1.1.101 cluster_password='6sJ09066sV1990;6'"
#ansible-playbook -i hosts create_node.yaml -e "host_group=gpu cluster_ip=10.1.1.101 cluster_password='6sJ09066sV1990;6'"


image='/mnt/pve/storage01/dump/vzdump-qemu-100-2024_01_26-08_59_33.vma.zst'
ansimble-playbook -i hosts restore_vm.yaml -e "host_name=caloba-v03 image=$image vmid=270 node_name=caloba70"

