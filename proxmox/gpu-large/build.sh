

#
# cluster configuration
#
clusterhost=caloba-v12
clusterhost_ip=10.1.1.112
clustername=gpu-large
password=$MASTER_KEY
image="/mnt/pve/storage01/dump//vzdump-qemu-100-2024_01_29-21_10_49.vma.zst" # full location


# 
# point to scripts
#
basepath=$REPO/proxmox/scripts


#
# reset all physical nodes
#
#ansible-playbook -i hosts reset_node.yaml -e "hostgroup=physical" 
#ansible-playbook -i hosts create_cluster.yaml -e "hostname=$clusterhost clustername=$clustername"
#sleep 10
#ansible-playbook -i hosts create_node.yaml -vv -e "hostgroup=physical clusterip=$clusterhost_ip masterkey=$password"

#sleep 5

#
# Build all nodes
#
# NOTE: script, master_key, physical_node, image_tag, vmname, vmid, last_two_digits_ip, snapshot_name, hosts_path
#source restore_vm.sh $password caloba-v12 $image caloba96 296 96 base hosts
#source restore_vm.sh $password caloba-v11 $image caloba94 294 94 base hosts
#source restore_vm.sh $password caloba-v11 $image caloba95 295 95 base hosts

source restore_vm.sh $password caloba-v09 $image caloba90 290 90 base hosts
source restore_vm.sh $password caloba-v09 $image caloba91 291 91 base hosts
source restore_vm.sh $password caloba-v10 $image caloba92 292 92 base hosts
source restore_vm.sh $password caloba-v10 $image caloba93 293 93 base hosts









