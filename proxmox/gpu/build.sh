

#
# cluster configuration
#
clusterhost=caloba-v01
clusterhost_ip=10.1.1.101
clustername=gpu
password=$MASTER_KEY
image="/mnt/pve/storage01/dump//vzdump-qemu-100-2024_01_29-21_10_49.vma.zst" # full location


# 
# point to scripts
#
basepath=$REPO/proxmox/scripts


#
# reset all physical nodes
#
#ansible-playbook -i $PWD/hosts $basepath/reset_node.yaml -e "hostgroup=gpu" 
#ansible-playbook -i $PWD/hosts $basepath/create_cluster.yaml -e "hostname=$clusterhost clustername=$clustername"
#ansible-playbook -i $PWD/hosts $basepath/create_node.yaml -vv -e "hostgroup=gpu clusterip=$clusterhost_ip masterkey=$password"

#sleep 5

#
# Build all nodes
#
# NOTE: script, master_key, physical_node, image_tag, vmname, vmid, last_two_digits_ip, snapshot_name, hosts_path
#source $basepath/restore_vm.sh $password caloba-v02 $image caloba70 270 70 base $PWD/hosts

#source restore_vm.sh $password caloba-v02 $image caloba71 271 71 base $PWD/hosts
#source restore_vm.sh $password caloba-v03 $image caloba72 272 72 base $PWD/hosts
#source restore_vm.sh $password caloba-v03 $image caloba73 273 73 base $PWD/hosts
#source restore_vm.sh $password caloba-v04 $image caloba74 274 74 base $PWD/hosts
#source restore_vm.sh $password caloba-v04 $image caloba75 275 75 base $PWD/hosts
#source restore_vm.sh $password caloba-v05 $image caloba76 276 76 base $PWD/hosts
#source restore_vm.sh $password caloba-v05 $image caloba77 277 77 base $PWD/hosts
#source restore_vm.sh $password caloba-v06 $image caloba78 278 78 base $PWD/hosts
source restore_vm.sh $password caloba-v06 $image caloba79 279 79 base $PWD/hosts
#source restore_vm.sh $password caloba-v07 $image caloba80 280 80 base $PWD/hosts
#source restore_vm.sh $password caloba-v07 $image caloba81 281 81 base $PWD/hosts
#source restore_vm.sh $password caloba-v08 $image caloba82 282 82 base $PWD/hosts
#source restore_vm.sh $password caloba-v08 $image caloba83 283 83 base $PWD/hosts










