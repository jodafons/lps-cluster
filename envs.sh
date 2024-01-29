


# virtualenv name
export VIRTUALENV_NAMESPACE='lps-cluster-env'

export CLUSTER_REPO_BASEPATH=$PWD

export MASTER_PASSWORD='6sJ09066sV1990;6'

export CLUSTER_HOST_ANSINBLE_PATH=$CLUSTER_REPO_BASEPATH/playbooks/hosts
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_EXECUTABLE=/bin/bash

export PATH=$PATH:$PWD/servers/slurm-server/scripts
#
# Set of commands
#
alias lps_play="ansible-playbook -i $CLUSTER_HOST_ANSINBLE_PATH -vv"
alias lps_ping="ansible all -m ping -v -i $CLUSTER_HOST_ANSINBLE_PATH"