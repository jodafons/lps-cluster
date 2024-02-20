


password=$MASTER_KEY
image_cuda12="/mnt/pve/storage01/dump/vzdump-qemu-100-2024_02_19-23_20_34.vma.zst" # full location
image="/mnt/pve/storage01/dump/vzdump-qemu-100-2024_02_19-22_23_55.vma.zst"



# 
# point to scripts
#
basepath=$REPO/proxmox/scripts


#
# reset all physical nodes
#
#ansible-playbook -i hosts playbooks/reset_node.yaml -e "hostgroup=gpu" 
#ansible-playbook -i hosts playbooks/reset_node.yaml -e "hostgroup=gpu-large" 
#ansible-playbook -i hosts playbooks/reset_node.yaml -e "hostgroup=cpu-large" 

#ansible-playbook -i hosts playbooks/create_cluster.yaml -e "hostname=caloba-v01 clustername=gpu"
#ansible-playbook -i hosts playbooks/create_cluster.yaml -e "hostname=caloba-v09 clustername=gpu-large"
#ansible-playbook -i hosts playbooks/create_cluster.yaml -e "hostname=caloba-v13 clustername=cpu-large"

#sleep 5
#ansible-playbook -i hosts playbooks/create_node.yaml -vv -e "hostgroup=gpu clusterip=10.1.1.101 masterkey=$password"
#ansible-playbook -i hosts playbooks/create_node.yaml -vv -e "hostgroup=gpu-large clusterip=10.1.1.109 masterkey=$password"
#ansible-playbook -i hosts playbooks/create_node.yaml -vv -e "hostgroup=cpu-large clusterip=10.1.1.113 masterkey=$password"


#
# Build all nodes
#
# NOTE: script, master_key, physical_node, image_tag, vmname, vmid, last_two_digits_ip, snapshot_name, hosts_path
#source restore_vm.sh $password caloba-v13 $image local caloba51 251 51 base hosts
#source restore_vm.sh $password caloba-v14 $image local caloba52 252 52 base hosts
source restore_vm.sh $password caloba-v15 $image local caloba53 253 53 base hosts
#source restore_vm.sh $password caloba-v16 $image local caloba54 254 54 base hosts



#source restore_vm.sh $password caloba-v09 $image_cuda12 local-lvm caloba90 290 90 base hosts
#source restore_vm.sh $password caloba-v09 $image_cuda12 local-lvm caloba91 291 91 base hosts
#source restore_vm.sh $password caloba-v10 $image_cuda12 local-lvm caloba92 292 92 base hosts
#source restore_vm.sh $password caloba-v10 $image_cuda12 local-lvm caloba93 293 93 base hosts
#source restore_vm.sh $password caloba-v11 $image_cuda12 local-lvm caloba94 294 94 base hosts
#source restore_vm.sh $password caloba-v11 $image_cuda12 local-lvm caloba95 295 95 base hosts
#source restore_vm.sh $password caloba-v12 $image_cuda12 local-lvm caloba96 296 96 base hosts





#source restore_vm.sh $password caloba-v03 $image_cuda12 local-lvm caloba70 270 70 base hosts
#source restore_vm.sh $password caloba-v03 $image_cuda12 local-lvm caloba71 271 71 base hosts
#source restore_vm.sh $password caloba-v04 $image_cuda12 local-lvm caloba72 272 72 base hosts
#source restore_vm.sh $password caloba-v04 $image_cuda12 local-lvm caloba73 273 73 base hosts
#source restore_vm.sh $password caloba-v05 $image_cuda12 local-lvm caloba74 274 74 base hosts
#source restore_vm.sh $password caloba-v05 $image_cuda12 local-lvm caloba75 275 75 base hosts
#source restore_vm.sh $password caloba-v06 $image_cuda12 local-lvm caloba76 276 76 base hosts
#source restore_vm.sh $password caloba-v06 $image_cuda12 local-lvm caloba77 277 77 base hosts
#source restore_vm.sh $password caloba-v07 $image_cuda12 local-lvm caloba78 278 78 base hosts
#source restore_vm.sh $password caloba-v07 $image_cuda12 local-lvm caloba79 279 79 base hosts
#source restore_vm.sh $password caloba-v08 $image_cuda12 local-lvm caloba80 280 80 base hosts
#source restore_vm.sh $password caloba-v08 $image_cuda12 local-lvm caloba81 281 81 base hosts










