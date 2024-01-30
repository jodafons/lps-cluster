password=$1
hostname=$2
image=$3
vmname=$4
vmid=$5
ipnumber=$6
snapname=$7
hosts=$8


# NOTE: this is default ip entrypoint for all new vms
vmname_init='caloba-base'

echo "restore..."
ansible-playbook -i $hosts restore_vm.yaml -vv -e "hostname=$hostname image=$image vmid=$vmid vmname=$vmname"
sleep 15
echo "network configuration..."
ansible-playbook -i $hosts configure_vm.yaml -vv -e "masterkey=$password vmname_init=$vmname_init vmname=$vmname ipnumber=$ipnumber"
sleep 10
echo "reset..."
ansible-playbook -i $hosts reset_vm.yaml -vv -e "hostname=$hostname vmid=$vmid"
echo "snapshot..."
echo 5
ansible-playbook -i $hosts snapshot_vm.yaml -vv -e "hostname=$hostname vmid=$vmid snapname=$snapname"
