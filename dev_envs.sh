
export CLUSTER_REPO_BASEPATH=$PWD

export CLUSTER_HOST_ANSINBLE_PATH=$CLUSTER_REPO_BASEPATH/playbooks/hosts
export ANSIBLE_HOST_KEY_CHECKING=False

#
# Set of commands
#
alias lps_play="ansible-playbook -i $CLUSTER_HOST_ANSINBLE_PATH -vv"
alias lps_ping="ansible all -m ping -v -i $CLUSTER_HOST_ANSINBLE_PATH"