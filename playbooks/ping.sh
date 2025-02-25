cluster=$1
ansible $cluster -m ping -v -i playbooks/templates/hosts
