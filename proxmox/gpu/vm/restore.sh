password=$1
hostname=$2
vmname=$3
vmid=$4
ipnumber=$5
snapname=$6


# source restore.sh $MASTER_KEY caloba-v08 caloba80 280 80


vmname_init='caloba-base'
image='/mnt/pve/storage01/dump/vzdump-qemu-100-2024_01_28-22_35_06.vma.zst'

echo "restore..."
ansible-playbook -i ../hosts restore_vm.yaml -vv -e "hostname=$hostname image=$image vmid=$vmid vmname=$vmname"
sleep 15
echo "network configuration..."
ansible-playbook -i ../hosts configure_vm.yaml -vv -e "masterkey=$password vmname_init=$vmname_init vmname=$vmname ipnumber=$ipnumber"
sleep 10
echo "reset..."
ansible-playbook -i ../hosts reset_vm.yaml -vv -e "hostname=$hostname vmid=$vmid"
echo "snapshot..."
echo 5
ansible-playbook -i ../hosts snapshot_vm.yaml -vv -e "hostname=$hostname vmid=$vmid snapname=$snapname"
