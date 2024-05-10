
password=$MASTER_KEY
image="/mnt/pve/storage01/dump/vzdump-qemu-100-2024_02_19-22_23_55.vma.zst"
basepath=$REPO/proxmox/scripts

source restore_vm.sh $password caloba-v13 $image local caloba51 252 51 base $LPS_CLUSTER_HOSTS
