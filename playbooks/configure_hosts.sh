ansible-playbook -i yaml/hosts yaml/host/configure_node.yaml -vv -e "hostgroup=gpu"
ansible-playbook -i yaml/hosts yaml/host/configure_node.yaml -vv -e "hostgroup=gpu-large"

