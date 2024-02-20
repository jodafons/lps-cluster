


password=$MASTER_KEY
image="/mnt/pve/storage01/dump/vzdump-qemu-100-2024_01_29-21_10_49.vma.zst" # full location


# 
# point to scripts
#
basepath=$REPO/proxmox/scripts


#
# reset all physical nodes
#
#ansible-playbook -i hosts reset_node.yaml -e "hostgroup=gpu" 
#ansible-playbook -i hosts reset_node.yaml -e "hostgroup=gpu-large" 
#ansible-playbook -i hosts reset_node.yaml -e "hostgroup=cpu-large" 

#ansible-playbook -i hosts create_cluster.yaml -e "hostname=caloba-v01 clustername=gpu"
#ansible-playbook -i hosts create_cluster.yaml -e "hostname=caloba-v09 clustername=gpu-large"
#ansible-playbook -i hosts create_cluster.yaml -e "hostname=caloba-v13 clustername=cpu-large"

#sleep 5
#ansible-playbook -i hosts create_node.yaml -vv -e "hostgroup=gpu clusterip=10.1.1.101 masterkey=$password"
#ansible-playbook -i hosts create_node.yaml -vv -e "hostgroup=gpu-large clusterip=10.1.1.109 masterkey=$password"
#ansible-playbook -i hosts create_node.yaml -vv -e "hostgroup=cpu-large clusterip=10.1.1.113 masterkey=$password"


#
# Build all nodes
#
# NOTE: script, master_key, physical_node, image_tag, vmname, vmid, last_two_digits_ip, snapshot_name, hosts_path
#source restore_vm.sh $password caloba-v13 $image caloba51 251 51 base hosts
#source restore_vm.sh $password caloba-v14 $image caloba52 252 52 base hosts
#source restore_vm.sh $password caloba-v15 $image caloba53 253 53 base hosts
#source restore_vm.sh $password caloba-v16 $image caloba54 254 54 base hosts



source restore_vm.sh $password caloba-v09 $image caloba90 290 90 base hosts
source restore_vm.sh $password caloba-v09 $image caloba91 291 91 base hosts
source restore_vm.sh $password caloba-v10 $image caloba92 292 92 base hosts
source restore_vm.sh $password caloba-v10 $image caloba93 293 93 base hosts
source restore_vm.sh $password caloba-v11 $image caloba94 294 94 base hosts
source restore_vm.sh $password caloba-v11 $image caloba95 295 95 base hosts
source restore_vm.sh $password caloba-v12 $image caloba96 296 96 base hosts









