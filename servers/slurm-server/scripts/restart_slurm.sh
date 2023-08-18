#!/bin/bash 

#!/bin/bash
while true
do
	echo "Ping all nodes..."
    sudo systemctl daemon-reload
    sudo systemctl enable slurmdbd
    sudo systemctl start slurmdbd
    sudo systemctl enable slurmctld
    sudo systemctl start slurmctld
    ansible-playbook -i $CLUSTER_HOST_ANSINBLE_PATH $CLUSTER_REPO_BASEPATH/playbooks/restart_slurmd.yaml

	sleep 300
done


