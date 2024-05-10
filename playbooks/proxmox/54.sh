
password=$MASTER_KEY
image="/mnt/pve/storage01/dump/vzdump-qemu-100-2024_02_19-22_23_55.vma.zst"
basepath=$REPO/proxmox/scripts

source restore_vm.sh $password caloba-v16 $image local caloba54 254 54 base $LPS_CLUSTER_HOSTS
