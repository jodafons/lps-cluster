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

    ansible-playbook -i playbooks/hosts playbooks/restart_slurm.yaml

	sleep 300
done


