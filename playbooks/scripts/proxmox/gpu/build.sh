

ansible-playbook -i hosts reset_node.yaml 
ansible-playbook -i hosts create_cluster.yaml -e "host_name=caloba-v01 cluster_name=gpu"
ansible-playbook -i hosts create_node.yaml -e "host_group=gpu cluster_ip=10.1.1.101 cluster_password='6sJ09066sV1990;6'"
ansible-playbook -i hosts create_node.yaml -e "host_group=gpu cluster_ip=10.1.1.101 cluster_password='6sJ09066sV1990;6'"


#/mnt/pve/storage01/dump/vzdump-qemu-253-2023_03_21-18_44_48.vma.zst

