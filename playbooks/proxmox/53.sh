
password=$MASTER_KEY
image="/mnt/pve/storage01/dump/vzdump-qemu-100-2024_02_19-22_23_55.vma.zst"
basepath=$REPO/proxmox/scripts

source restore_vm.sh $password caloba-v15 $image local caloba53 253 53 base $LPS_CLUSTER_HOSTS
