


export MASTER_KEY='6sJ09066sV1990;6'



export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_EXECUTABLE=/bin/bash
export SLURM_PLAYBOOKS=$PWD/playbooks/slurm
export LPS_CLUSTER_HOSTS=$PWD/playbooks/hosts

export PATH=$PATH:/$PWD/scripts

#
# Set of commands
#
#alias lps_play="ansible-playbook -i $CLUSTER_HOST_ANSINBLE_PATH -vv"
#alias lps_ping="ansible all -m ping -v -i $CLUSTER_HOST_ANSINBLE_PATH"