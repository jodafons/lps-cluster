password=$1
hostname=$2
image=$3
storage=$4
vmname=$5
vmid=$6
ipnumber=$7
snapname=$8
hosts=$9


# NOTE: this is default ip entrypoint for all new vms
vmname_init='caloba-base'

echo "restore..."
ansible-playbook -i $hosts scripts/restore_vm.yaml -vv -e "hostname=$hostname image=$image vmid=$vmid vmname=$vmname storage=$storage"
sleep 30
echo "network configuration..."
ansible-playbook -i $hosts scripts/configure_vm.yaml -vv -e "masterkey=$password vmname_init=$vmname_init vmname=$vmname ipnumber=$ipnumber"
sleep 20
echo "reset..."
ansible-playbook -i $hosts scripts/reset_vm.yaml -vv -e "hostname=$hostname vmid=$vmid"
echo "snapshot..."
echo 5
ansible-playbook -i $hosts scripts/snapshot_vm.yaml -vv -e "hostname=$hostname vmid=$vmid snapname=$snapname"
