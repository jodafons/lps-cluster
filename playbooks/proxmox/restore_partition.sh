partition=$1
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i hosts scripts/reset_node.yaml -e "hostgroup=$partition" 
