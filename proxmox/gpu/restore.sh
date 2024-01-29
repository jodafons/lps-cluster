

image='/mnt/pve/storage01/dump/vzdump-qemu-100-2024_01_28-22_35_06.vma.zst'
#ansible-playbook -i hosts restore_vm.yaml -vv -e "host_name=caloba-v08 image=$image vmid=280 node_name=caloba80"


ansible-playbook -i hosts configure_vm.yaml -vv -e "cluster_password=$MASTER_PASSWORD new_hostname=caloba80 node_number=80"
